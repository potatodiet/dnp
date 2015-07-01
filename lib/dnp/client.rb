require "socket"

module Dnp
  class Client
    def initialize(host, port)
      @socket = UDPSocket.new
      @socket.connect(host, port)

      @id = 0
      # The server will initialize our client if we send an id of 0.
      send("")

      @id = @socket.recv(2).unpack("S")[0].to_i
    end

    def send(message)
      @socket.send(
        [message.bytesize, @id].pack("S*"), 0
      )
      @socket.send(message, 0) if message.size > 0
      @socket.flush
    end

    def receive
      header = @socket.recv(2)
      size = header.unpack("S")[0].to_i
      @socket.recv(size)
    end
  end
end

