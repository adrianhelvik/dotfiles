vimgrep() {
    for f in $(rg -l $@)
    do
        vim "$f"
        sleep 0.5
    done
}
