# Parse a curl command string into structured data
# Usage: "curl -H ..." | from curl
# Or:    $curl_str | from curl
def "from curl" []: string -> record {
    let flat = $in
        | str replace --all "\\\n" " "
        | str replace --regex ' {2,}' " "
        | str trim

    let headers = $flat
        | parse --regex '-H "(?P<h>[^"]+)"'
        | get h
        | each {|line|
            let parts = $line | split row ": "
            { name: $parts.0, value: ($parts | skip 1 | str join ": ") }
        }

    let url_matches = $flat | parse --regex '"(https?://[^\s"]+)"' | get capture0
    let url = if ($url_matches | length) > 0 {
        $url_matches | last
    } else {
        $flat | split row " " | where {|w| $w | str starts-with "http"} | first
    }

    let method_match = $flat | parse --regex '(?:-X|--request) (?P<m>[A-Z]+)'
    let method = if ($method_match | length) > 0 {
        $method_match | get m | first
    } else if ($flat | str contains "--data") or ($flat | str contains " -d ") {
        "POST"
    } else {
        "GET"
    }

    let body_match = $flat | parse --regex '(?:--data-raw|--data|-d) "(?P<b>[^"]+)"'
    let body = if ($body_match | length) > 0 {
        $body_match | get b | first
    } else {
        null
    }

    { method: $method, url: $url, headers: $headers, body: $body }
}

# Execute a curl command string using nushell's http commands
# Usage: "curl ..." | run curl
def "run curl" []: string -> any {
    let c = $in | from curl
    let h = $c.headers | reduce -f {} {|it, acc| $acc | insert $it.name $it.value }

    match $c.method {
        "GET"    => { http get    --headers $h $c.url }
        "POST"   => { http post   --headers $h $c.url ($c.body | default "") }
        "PUT"    => { http put    --headers $h $c.url ($c.body | default "") }
        "DELETE" => { http delete --headers $h $c.url }
        _        => { http get    --headers $h $c.url }
    }
}
