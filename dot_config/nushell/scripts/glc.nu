def "nu-complete glc pull" [] {
    mut dir = $env.PWD
    loop {
        let cache = ($dir | path join ".glc-cache")
        if ($cache | path exists) {
            return (open $cache | lines | where ($it | str trim) != "")
        }
        let parent = ($dir | path dirname)
        if $parent == $dir { break }
        $dir = $parent
    }
    []
}

def "nu-complete glc push" [] {
    mut dir = $env.PWD
    loop {
        let gitlab = ($dir | path join ".gitlab")
        if ($gitlab | path exists) {
            return (
                ls $dir
                | where name =~ '\.env$'
                | get name
                | path basename
                | str replace --regex '\.env$' ''
            )
        }
        let parent = ($dir | path dirname)
        if $parent == $dir { break }
        $dir = $parent
    }
    []
}

extern "glc list" []

extern "glc pull" [
    env_name: string@"nu-complete glc pull"
]

extern "glc push" [
    env_name: string@"nu-complete glc push"
    --yes(-y)
]
