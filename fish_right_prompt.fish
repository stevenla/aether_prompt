function fish_right_prompt
    set -l status_copy $status
    set -l status_color cyan

    if test "$status_copy" -ne 0
        set status_color red
    end

    if test "$CMD_DURATION" -gt 100
        set -l duration_copy $CMD_DURATION
        set -l duration (echo $CMD_DURATION | humanize_duration)

         echo -sn (set_color $status_color) "$duration" (set_color normal)

    else if set -l last_job_id (last_job_id -l)
         echo -sn (set_color $status_color) "%$last_job_id" (set_color normal)
    else
         echo -sn (set_color black) (date "+%H:%M") (set_color normal)
    end
end
