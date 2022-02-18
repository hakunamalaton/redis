require "redis"
require "minitest/autorun"

# 6379 for official redis, 6380 for ours
SERVER_PORT = ENV["SERVER_PORT"]

class TestRedisServer < Minitest::Test
  def test_responds_to_ping
    r = Redis.new(port: SERVER_PORT)
    assert_equal "PONG", r.ping
  end

  def test_multiple_commands_from_same_client
    r = Redis.new(port: SERVER_PORT)
    # The Redis client re-connects on timeout by default, without_reconnect
    # prevents that.
    r.without_reconnect do
        assert_equal "PONG", r.ping
        assert_equal "PONG", r.ping
    end
end

  def test_multiple_clients
    r1 = Redis.new(port: SERVER_PORT)
    r2 = Redis.new(port: SERVER_PORT)

    assert_equal "PONG", r1.ping
    assert_equal "PONG", r2.ping
  end

  def test_responds_to_echo
         r = Redis.new(port: SERVER_PORT)
         assert_equal "hey", r.echo("hey")
         assert_equal "hello", r.echo("hello")
       end
    
end

class TestRESPDecoder < Minitest::Test
    def test_simple_string
      assert_equal "OK", RESPDecoder.decode("+OK\r\n")
      assert_equal "HEY", RESPDecoder.decode("+HEY\r\n")
      assert_raises(IncompleteRESP) { RESPDecoder.decode("+") }
      assert_raises(IncompleteRESP) { RESPDecoder.decode("+OK") }
      assert_raises(IncompleteRESP) { RESPDecoder.decode("+OK\r") }
    end
  end

# decode ECHO hey get 23 bytes total

