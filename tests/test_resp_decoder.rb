require "minitest/autorun"
  
  class TestRESPDecoder < Minitest::Test
    def test_simple_string
      assert_equal "OK", RESPDecoder.decode("+OK\r\n")
      assert_equal "HEY", RESPDecoder.decode("+HEY\r\n")
      assert_raises(IncompleteRESP) { RESPDecoder.decode("+") }
      assert_raises(IncompleteRESP) { RESPDecoder.decode("+OK") }
      assert_raises(IncompleteRESP) { RESPDecoder.decode("+OK\r") }
    end
  
    def test_bulk_string
      assert_equal "OK", RESPDecoder.decode("$2\r\nOK\r\n")
      assert_equal "HEY", RESPDecoder.decode("$3\r\nHEY\r\n")
      assert_equal "HEY", RESPDecoder.decode("$3\r\nHEY\r\n")
      assert_raises(IncompleteRESP) { RESPDecoder.decode("$") }
      assert_raises(IncompleteRESP) { RESPDecoder.decode("$2") }
      assert_raises(IncompleteRESP) { RESPDecoder.decode("$2\r") }
      assert_raises(IncompleteRESP) { RESPDecoder.decode("$2\r\n") }
      assert_raises(IncompleteRESP) { RESPDecoder.decode("$2\r\nOK") }
      assert_raises(IncompleteRESP) { RESPDecoder.decode("$2\r\nOK\r") }
    end
 
   def test_arrays
     assert_equal ["PING"], RESPDecoder.decode("*1\r\n$4\r\nPING\r\n")
     assert_equal ["ECHO", "hey"], RESPDecoder.decode("*2\r\n$4\r\nECHO\r\n$3\r\nhey\r\n")
     assert_raises(IncompleteRESP) { RESPDecoder.decode("*") }
     assert_raises(IncompleteRESP) { RESPDecoder.decode("*1") }
     assert_raises(IncompleteRESP) { RESPDecoder.decode("*1\r\n") }
     assert_raises(IncompleteRESP) { RESPDecoder.decode("*1\r\n$4") }
     assert_raises(IncompleteRESP) { RESPDecoder.decode("*2\r\n$4\r\nECHO\r\n") }
   end
  end