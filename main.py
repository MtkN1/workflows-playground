import httpx

r = httpx.get("https://example.com")
print(r.status_code + "42")
