info("Running packet tests")

function on_msg(topic, payload)
    info("Received message topic: [", topic, "] payload: [", String(payload), "]")
    @test topic == "abc"
    @test String(payload)== "qwerty"
end

function is_out_correct(filename_expected::AbstractString, actual::Channel{UInt8}, mid::UInt16)
    file_data = read_all_to_arr(filename_expected)
    actual_data = Vector{UInt8}()

    for i in file_data
      append!(actual_data, take!(actual))
    end

    mid_index = get_mid_index(file_data)
    if mid_index > 0
      buffer = PipeBuffer()
      write(buffer, mid)
      converted_mid = take!(buffer)
      file_data[mid_index] = converted_mid[2]
      file_data[mid_index+1] = converted_mid[1]
    end

    correct = true
    i = 1
    while i <= length(file_data)
      if file_data[i] != actual_data[i]
        correct = false
        break
      end
      i += 1
    end
    return correct
end

function is_out_correct(filename_expected::AbstractString, actual::Channel{UInt8})
    file = open(filename_expected, "r")
    correct = true
    while !eof(file)
        if read(file, UInt8) != take!(actual)
            correct = false
            break
        end
    end
    return correct
end

function test()
    client = Client(on_msg)
    last_id::UInt16 = 0x0001

    info("Testing connect")
    connect(client, "test.mosquitto.org", client_id="TestID")
    tfh::TestFileHandler = client.socket
    @test is_out_correct("data/output/connect.dat", tfh.out_channel)
    # CONNACK is automatically being sent in connect call

    info("Testing subscribe")
    subscribe_async(client, "abc", 0x01, "cba", 0x00)
    put_from_file(tfh, "data/input/suback.dat", client.last_id)
    @test is_out_correct("data/output/subreq.dat", tfh.out_channel, client.last_id)

    info("Testing unsubscribe")
    unsubscribe_async(client, "abc", "cba")
    put_from_file(tfh, "data/input/unsuback.dat", client.last_id)
    @test is_out_correct("data/output/unsubreq.dat", tfh.out_channel, client.last_id)

    info("Testing receive publish QOS 0")
    put_from_file(tfh, "data/input/qos0pub.dat")

    info("Testing receive publish QOS 1")
    put_from_file(tfh, "data/input/qos1pub.dat", last_id)
    @test is_out_correct("data/output/puback.dat", tfh.out_channel, last_id)
    #last_id += 1

    info("Testing receive publish QOS 2")
    put_from_file(tfh, "data/input/qos2pub.dat", last_id)
    @test is_out_correct("data/output/pubrec.dat", tfh.out_channel, last_id)
    put_from_file(tfh, "data/input/pubrel.dat", last_id)
    @test is_out_correct("data/output/pubcomp.dat", tfh.out_channel, last_id)
    #last_id += 1

    info("Testing send publish QOS 0")
    publish_async(client, "test1", "QOS_0", qos=0x00)
    @test is_out_correct("data/output/qos0pub.dat", tfh.out_channel)

    info("Testing send publish QOS 1")
    publish_async(client, "test2", "QOS_1", qos=0x01)
    put_from_file(tfh, "data/input/puback.dat", client.last_id)
    @test is_out_correct("data/output/qos1pub.dat", tfh.out_channel, client.last_id)


    info("Testing send publish QOS 2")
    publish_async(client, "test3", "test", qos=0x02)
    @test is_out_correct("data/output/qos2pub.dat", tfh.out_channel, client.last_id)
    put_from_file(tfh, "data/input/pubrec.dat", client.last_id)
    @test is_out_correct("data/output/pubrel.dat", tfh.out_channel, client.last_id)
    put_from_file(tfh, "data/input/pubcomp.dat", client.last_id)

    info("Testing disconnect")
    disconnect(client)
    @test is_out_correct("data/output/disco.dat", tfh.out_channel)

    #This has to be in it's own connect flow to not interfere with other messages
    info("Testing keep alive with response")
    client = Client(on_msg)
    client.ping_timeout = 1
    connect(client, "test.mosquitto.org", client_id="TestID", keep_alive=0x0001)
    tfh = client.socket
    @test is_out_correct("data/output/connect_keep_alive1s.dat", tfh.out_channel) # Consume output
    @test is_out_correct("data/output/pingreq.dat", tfh.out_channel)
    put_from_file(tfh, "data/input/pingresp.dat")

    info("Testing keep alive without response")
    sleep(1.1)
    @test is_out_correct("data/output/pingreq.dat", tfh.out_channel)
    @test is_out_correct("data/output/disco.dat", tfh.out_channel)

    info("Testing unwanted pingresp")
    client = Client(on_msg)
    connect(client, "test.mosquitto.org", client_id="TestID", keep_alive=0x000F)
    tfh = client.socket
    put_from_file(tfh, "data/input/pingresp.dat")
    sleep(0.1)
    @test tfh.closed
end

test()
