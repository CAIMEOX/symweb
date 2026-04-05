///|
fn test_request_json() -> String {
  "{\"function_id\":\"simplify\",\"source\":\"x + x\",\"parser\":{\"caret_as_power\":true,\"evaluate\":true,\"implicit_multiplication\":false,\"implicit_application\":false,\"function_exponentiation\":false,\"factorial_notation\":false,\"convert_equals_signs\":false}}"
}

///|
fn bridge_response_json() -> String {
  kernel_reset_request()
  for byte in @utf8.encode(test_request_json()) {
    kernel_push_request_byte(byte.to_int())
  }
  let response_len = kernel_evaluate_request()
  let response_bytes = Bytes::makei(response_len, fn(index) {
    kernel_result_byte(index).to_byte()
  })
  @utf8.decode_lossy(response_bytes)
}

///|
test "plain wasm bridge round-trips JSON evaluation requests" {
  let payload = @json.parse(bridge_response_json())
  match payload {
    Array([
      String("Success"),
      Object(result),
    ]) => {
      guard result.get("parsed_expression") == Some(Json::string("2*x")) else {
        fail("Unexpected parsed expression payload: \{payload.stringify()}")
      }
      guard result.get("fields") is Some(Array([Object(field), ..])) else {
        fail("Expected at least one result field in payload: \{payload.stringify()}")
      }
      assert_eq(field.get("label"), Some(Json::string("Result")))
      assert_eq(field.get("value"), Some(Json::string("2*x")))
    }
    _ => fail("Expected success payload, got: \{payload.stringify()}")
  }
}
