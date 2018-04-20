defmodule KV.RegistryTest do
  use ExUnit.Case, async: true

  setup do
    # start_supervised! instead of Registry.start_link
    # bc ExUnit will make sure the process is shutdown
    # before the next test starts
    registry = start_supervised!(KV.Registry)
    %{registry: registry}
  end

  test "spawns buckets", %{registry: registry} do
    assert KV.Registry.lookup(registry, "shopping") == :error

    KV.Registry.create(registry, "shopping")
    # "bucket" is like my party
    assert {:ok, bucket} = KV.Registry.lookup(registry, "shopping")

    # all KV.Bucket is like DnD.Party.join/list/destroy
    KV.Bucket.put(bucket, "milk", 1)
    assert KV.Bucket.get(bucket, "milk")
  end

  test "removes buckets on exit", %{registry: registry} do
    KV.Registry.create(registry, "shopping")
    {:ok, bucket} = KV.Registry.lookup(registry, "shopping")

    Agent.stop(bucket)
    assert KV.Registry.lookup(registry, "shopping") == :error
  end
end
