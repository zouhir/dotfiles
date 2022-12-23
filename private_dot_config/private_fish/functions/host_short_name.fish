function host_short_name
  switch (hostname)
  case "zouhir.c.googlers.com"
    echo zouhir-ct
  case "zouhirlite.c.googlers.com"
    echo zouhirlite-ct
  case '*'
    hostname -s
  end
end
