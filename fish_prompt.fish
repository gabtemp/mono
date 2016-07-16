function fish_prompt
    set -l status_copy $status
    set -l pwd_info (pwd_info "/")
    set -l dir
    set -l base
    set -l color (set_color white)
    set -l color2 (set_color normal)
    set -l color3 (set_color $fish_color_command)
    set -l color_error (set_color $fish_color_error)
    set -l color_normal "$color2"

    echo -sn " "

    if test "$status_copy" -ne 0
        set color "$color_error"
        set color2 "$color_error"
        set color3 "$color_error"
    end

    set -l glyph " $color2\$$color_normal"

    if test 0 -eq (id -u "$USER")
        echo -sn "$color_error# $color_normal"
    end

    if test ! -z "$SSH_CLIENT"
        set -l color "$color2"

        if test 0 -eq (id -u "$USER")
            set color "$color_error"
        end

        echo -sn "$color"(host_info "user@")"$color_normal"
    end

    if test "$PWD" = ~
        set base "$color3~"
        set glyph
        
    else if pwd_is_home
        set dir

    else
        if test "$PWD" = /
            set glyph
        else
            set dir "/"
        end

        set base "$color_error/"
    end

    if test ! -z "$pwd_info[1]"
        set base "$pwd_info[1]"
    end

    if test ! -z "$pwd_info[2]"
        set dir "$dir$pwd_info[2]/"
    end

    echo -sn "$color2$dir$color$base$color_normal"

    if test ! -z "$pwd_info[3]"
        echo -sn "$color2/$pwd_info[3]"
    end

    if set branch_name (hg_branch_name)
        set -l hg_color
        set -l hg_glyph \$

        # TODO: add replacement for staged?
        # if git_is_staged
        #    set hg_color (set_color green)
        # else
        if hg_is_touched
            set hg_color "$color_error"
        else
            set hg_color "$color3"
        end

        set -l hg_ahead (hg_ahead)

        if test "$branch_name" = "default"
            set branch_name
            if hg_is_shelved
                set branch_name "{}"
            end
        else
            set -l left_par "("
            set -l right_par ")"

            if hg_is_shelved
                set left_par "{"
                set right_par "}"
            end

            set branch_name " $hg_color$left_par$color2$branch_name$hg_color$right_par"
        end

        echo -sn "$branch_name$hg_color$hg_ahead $hg_glyph"
    else
        echo -sn "$color$glyph$color_normal"
    end

    echo -sn "$color_normal "
end
