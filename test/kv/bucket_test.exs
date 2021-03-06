defmodule KV.BucketTest do
  use ExUnit.Case, async: true

  setup do
    bucket = start_supervised!(KV.Bucket, [])
    %{bucket: bucket}
  end

  test "stores values by key", %{bucket: bucket} do
    assert KV.Bucket.get(bucket, "milk") == nil

    KV.Bucket.put(bucket, "milk", 3)
    assert KV.Bucket.get(bucket, "milk") == 3
  end

  test "removes a key and gives value", %{bucket: bucket} do
    KV.Bucket.put(bucket, "milk", 3)
    assert KV.Bucket.delete(bucket, "milk") == 3

    assert KV.Bucket.get(bucket, "milk") == nil
  end

  test "has multiple things", %{bucket: bucket} do
    KV.Bucket.put(bucket, "juice", 1)
    KV.Bucket.put(bucket, "milk", 2)

    assert KV.Bucket.get(bucket, "juice") == 1
    assert KV.Bucket.get(bucket, "milk") == 2
  end
end
