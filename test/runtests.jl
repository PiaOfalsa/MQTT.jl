import Base: connect, read, write, close
import MQTT: read_len, Message
using Base.Test, MQTT

include("smoke.jl")
include("mocksocket.jl")
include("packet.jl")
