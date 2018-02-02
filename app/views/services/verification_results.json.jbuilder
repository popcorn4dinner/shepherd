 json.array!(@verification_results) do |result|
  json.verifier result.verifier_name
  json.message result.message
  json.success result.success
end
