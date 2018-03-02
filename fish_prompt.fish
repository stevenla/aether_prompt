# sla_fish

function __git_upstream_configured
    git rev-parse --abbrev-ref @"{u}" > /dev/null 2>&1
end

function __print_color
    set -l color  $argv[1]
    set -l string $argv[2]

    set_color $color
    printf $string
    set_color normal
end

function fish_prompt -d "sla's fish prompt"
    echo -e ""
    set -l gray 555

    # User
    #
    set -l user (id -un $USER)
    __print_color cyan "$user"


    # Host
    #
    set -l host_name (hostname -s)
    set -l host_glyph "@"

    __print_color "$gray" "$host_glyph"
    __print_color blue "$host_name"


    # Current working directory
    #
    set -l pwd_glyph ":"
    set -l pwd_string (echo $PWD | sed 's|^'$HOME'\(.*\)$|~\1|')

    __print_color "$gray" "$pwd_glyph"
    __print_color green "$pwd_string"


    # Git
    #
    if git_is_repo
        set -l branch_name (git_branch_name)
        set -l git_glyph_prefix " ("
        set -l git_glyph_suffix ")"
        set -l git_branch_glyph

        __print_color yellow "$git_glyph_prefix"
        __print_color yellow "$branch_name"

        if git_is_touched
            if git_is_staged
                if git_is_dirty
                    set git_branch_glyph "±"
                else
                    set git_branch_glyph "+"
                end
            else
                set git_branch_glyph "?"
            end
        end

        __print_color red "$git_branch_glyph"

        if __git_upstream_configured
             set -l git_ahead (command git rev-list --left-right --count HEAD...@"{u}" ^ /dev/null | awk '
                $1 > 0 { printf("⇡") } # can push
                $2 > 0 { printf("⇣") } # can pull
             ')

             if test ! -z "$git_ahead"
                __print_color red "$git_ahead"
            end
        end

        __print_color yellow "$git_glyph_suffix"
    end

    __print_color "$gray" "\n› "
end
