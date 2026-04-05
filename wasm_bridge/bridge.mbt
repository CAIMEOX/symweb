///|
let request_buffer : @buffer.Buffer = @buffer.new()

///|
let response_bytes_ref : Ref[Bytes] = { val: b"" }

///|
pub fn run_eval_json(request_json : String) -> String {
  @kernel.evaluate_json(request_json)
}

///|
fn decode_request_json() -> String {
  @utf8.decode_lossy(request_buffer.to_bytes())
}

///|
fn encode_response_json(response_json : String) -> Bytes {
  @utf8.encode(response_json)
}

///|
pub fn kernel_reset_request() -> Unit {
  request_buffer.reset()
  response_bytes_ref.val = b""
}

///|
pub fn kernel_push_request_byte(byte : Int) -> Unit {
  request_buffer.write_byte(byte.to_byte())
}

///|
pub fn kernel_evaluate_request() -> Int {
  let response_json = run_eval_json(decode_request_json())
  let response_bytes = encode_response_json(response_json)
  response_bytes_ref.val = response_bytes
  response_bytes.length()
}

///|
pub fn kernel_result_length() -> Int {
  response_bytes_ref.val.length()
}

///|
pub fn kernel_result_byte(index : Int) -> Int {
  response_bytes_ref.val[index].to_int()
}
