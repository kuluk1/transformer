### Run

`mix run --no-halt`


### curl

```
curl -X POST 'http://localhost:8080/transform?strict=false' \
   -H 'Content-Type: application/json' \
   -d '{"input":"ciao","operation":"lower"}'
```