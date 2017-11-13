# Import package
import paho.mqtt.client as mqtt

# Define Variables
MQTT_HOST = "iot.eclipse.org"
MQTT_PORT = 1883
MQTT_KEEPALIVE_INTERVAL = 5
MQTT_TOPIC = "SampleTopic"
MQTT_MSG = "Hello MQTT"


# Define on_connect event Handler
def on_connect(mosq, userdata, obj, rc):
	print ("Connected to MQTT Broker")
		#Subscribe to a the Topic
	mqttc.subscribe(MQTT_TOPIC, 0)

# Define on_publish event Handler
def on_publish(client, userdata, mid):
	print ("Message Published...")

# Define on_subscribe event Handler
def on_subscribe(mosq, obj, mid, granted_qos):
    print ("Subscribed to MQTT Topic")


# Define on_message event Handler
def on_message(mosq, obj, msg):
	print (msg.payload)

# Initiate MQTT Client
mqttc = mqtt.Client()

# Register Event Handlers

mqttc.on_message = on_message
mqttc.on_publish = on_publish
mqttc.on_connect = on_connect
mqttc.on_subscribe = on_subscribe

# Connect with MQTT Broker
mqttc.connect(MQTT_HOST, MQTT_PORT, MQTT_KEEPALIVE_INTERVAL)

# Publish message to MQTT Topic
mqttc.publish(MQTT_TOPIC,MQTT_MSG)

# Disconnect from MQTT_Broker
mqttc.disconnect()
