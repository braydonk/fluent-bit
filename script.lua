function process(tag, timestamp, record)
    record["hello"] = "world"
    return 2, timestamp, record
end