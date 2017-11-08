# Public methods

# TODO getter
function topic(client)
end

# TODO setter
function topic(client, value)
end

# TODO websocket
function ws_set_options(client, path, headers)
end

# TODO ssl
function tls_set_context(client, context)
end

# TODO ssl
function tls_set(client, ca_certs, certfile, keyfile, cert_reqs, tls_version, ciphers)
end

# TODO ssl
function tls_insecure_set(client, value)
end

# TODO logging
function enable_logger(client, logger)
end

# TODO logging
function disable_logger(client)
end

# Resets the client. Useful because client will attempt to resend messages still in queue after reconnect
function reinitialise(client, client_id, clean_session, userdata)
end

function connect(client, host, port, keepalive, bind_address)
end

function connect_srv(client, domain, keepalive, bind_address)
end

function connect_async(client, host, port, keepalive, bind_address)
end

function reconnect_delay_set(client, min_delay, max_delay)
end

function reconnect(client)
end

function publish(client, topic, payload, qos, retain)
end

# TODO setter
function username_pw_set(client, username, password)
end

function disconnect(client)
end

function subscribe(client, topic, qos)
end

function unsubscribe(client, topic)
end

# Used if client wants to handle the reads himself. Shouldn't be used if loop_start() is being used
function loop_read(client, max_packets)
end

# Used if client wants to handle the writes himself. Shouldn't be used if loop_start() is being used
function loop_write(client, max_packets)
end

# Used to determine wether or not there is network data to be written. Useful if client is using select himself
function want_write(client)
end

# Used to process miscellanous network events. Shouldn't be used if loop_start() is being used
function loop_misc(client)
end

# TODO setter
function max_inflight_messages_set(client, inflight)
end

# TODO setter
function max_queued_messages_set(client, queue_size)
end

# TODO setter
function message_retry_set(client, retry)
end

# TODO setter
function user_data_set(client, userdata)
end

# TODO setter
function will_set(client, topic, payload, qos, retain)
end

# deletes the current will in client. Not strictly necessary
function will_clear(client)
end

# TODO getter
function socket(client)
end

# Calls loop in an infite blocking loop. Useful if the MQTT client loop is the only thing you want to run in your program
# TODO Does this still make sense?
function loop_forever(client, timeout, max_packets, retry_first_connection)
end

# Starts the loop to process network traffic in a thread, if you don't want to call loop repeatedly yourself
function loop_start(client)
end

# Stops the network loops
function loop_stop(client, force)
end

# TODO is this necessary?
function message_callback_add(client, sub, callback)
end

# TODO is this necessary?
function message_callback_remove(client, sub)
end

# Private

#TODO desc
function in_loop(client)
end

#TODO desc
function out_loop(client)
end

# TODO what does this do?
function loop_rc_handle(client, rc)
end

function packet_read(client)
end

function packet_write(client)
end

# TODO logger
function easy_log(client, level, fmt, args)
end

# TODO ?
function check_keepalive(client)
end

# Returns the next valid message id
function mid_generate(client)
end

# Helper method to check if it is possible to publish to topic
function topic_wildcard_len_check(topic)
end

# Helper method to check if it is possible to publish to topic
function filter_wildcard_len_check(sub)
end

function send_pingreq(client)
end

function send_pingresp(client)
end

# MQTTMessageInfo helper methods

# Wait until the associated message has been published
function wait_for_publish(info::MQTTMessageInfo)
end

# Could be needed to notify threads waiting for this message to get published
function set_published(info::MQTTMessageInfo)
end

# TODO rework method arguments, some get the entire client but only need a couple elements. Maybe it's better to only give them those specifically

function send_puback(client, mid)
end

function send_pubcomp(client, mid)
end

# Pack the remaining length field in the packet appropriately
function pack_remaining_length(packet, remaining_length)
end

# Pack 2 bytes of length-prefixed data into header.
function pack_str16(packet, data)
  # Strings need to be UTF-8
end

function send_publish(client, mid, topic, payload, qos, info, retain=false, dup=false)
  # Assumes topic and payload are properly encoded
end

function send_pubrec(client)
end

function send_pubrel(client)
end

# For PUBACK, PUBCOMP, PUBREC, and PUBREL
function send_command_with_mid(client, command, mid, dup)
end

# For DISCONNECT, PINGREQ and PINGRESP
function send_simple_command(client, command)
end

function send_connect(client, keepalive, clean_session)
end

function send_disconnect(client)
end

function send_subscribe(client, topic, dup)
end

function send_unsubscribe(client, topic, dup)
end

# Checks the state of each message and retries accordingly
function message_retry_check_actual(client, messages, mutex)
end

# Calls message_retry_check_actual for in- and outbound messages
function message_retry_check(client)
end

# Resets all outbound messages on reconnect TODO ?
function messages_reconnect_reset_out(client)
end

# Resets all inbound messages on reconnect TODO ?
function messages_reconnect_reset_in(client)
end

# Calls messages_reconnect_reset_in and messages_reconnect_reset_out
function messages_reconnect_reset(client)
end

# Queue a new packet and break out of select if in threaded mode (called packet_queue in python) TODO ?
function queue_packet(client, command, packet, mid, qos, info)
end

function handle_packet(packet)
end

function handle_pingreq(client)
end

function handle_pingresp(client)
end

function handle_connack(client)
end

function handle_suback(client)
end

function handle_publish(client)
end

function handle_pubrel(client)
end

function handle_pubrec(client)
end

function handle_unsuback(client)
end

function handle_pubackcomp(client)
end

# TODO ?
function handle_on_message(client)
end

# Sends out queued up messages until max_inflight_messages is reached
function update_inflight(client)
end

# Reduces inflight_messages and calls update_inflight()
function do_on_publish(client, idx, mid)
end

#TODO this calls loop_forever this might need to get reworked for Julia
function thread_main()
end

# Waits the appropriate time for reconnectiong and adjusts reconnect time
function reconnect_wait(client)
end

# Websocket methods
function do_handshake(client, extra_headers)
end

function create_frame(client, opcode, data, do_masking=1)
end

function buffered_read(client, length)
end

function recv_impl(client, length)
end

function send_impl(client, data)
end

function close(client)
end

#TODO ?!
function fileno(client)
end

function pending(client)
end

function set_blocking(client, flag)
end

# These are all helper methods that call send_impl and recv_impl accordingly
function recv(client, length)
end

function read(client, length)
end

function send(client, data)
end

function write(client, data)
end

#=struct Client
  keep_alive::UInt16
  on_msg::Function
  socket::TCPSocket
end

function write_msg(client, cmd, payload...)
  # TODO rewrite method
  buffer = PipeBuffer()
  for i in payload
    if typeof(i) === String
      write(buffer, hton(convert(UInt16, length(i))))
    end
    write(buffer, i)
  end
  data = take!(buffer)
  len = hton(convert(UInt8, length(data)))
  write(client.socket, cmd, len, data)
end

function read_msg(client)
  #TODO rewrite method
  cmd = read(client.socket, UInt8)
  len = read(client.socket, UInt8)

  if cmd === CONNACK
    rc = read(client.socket, UInt16)
    println(rc)
  end
end

function connect(host::AbstractString, port::Int, on_msg::Function)
  #TODO rewrite method
  client = Client(0, on_msg, connect(host, port))
  protocol = "MQTT"
  protocol_version = 0x04
  flags = 0x02 # clean session
  client_id = "julia"
  write_msg(client, CONNECT, protocol, protocol_version, flags, client.keep_alive, client_id)
  println("connected to ", host, ":", port)

  read_msg(client)

  client
end

function disconnect(client)
  #TODO rewrite method
  write_msg(client, DISCONNECT)
  close(client.socket)
  println("disconnected")
end

function subscribe(client, topics...)
end

function publish(client, topic, bytes)
end=#