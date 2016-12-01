module Authority
    def can_view(levelLimit)


        if current_user.nil?
            return false
        end
        if current_user.level.nil?
            return false
        end
        if current_user.level < levelLimit
            return false
        end
        return true
    end
    def can_add_issue()
        return can_view(0)
    end
    def can_add_detail()
        return can_view(0)
    end
    def can_add_comment()
        return can_view(0)
    end
    def can_editor_issue()
        if can_view(2)
            return true
        else
            return false
        end
    end
    def can_like()
        return can_view(0)
    end
    def can_Trial()
        return can_view(2)
    end
    def can_level_up_issue()
        return can_view(2)
    end
    def can_hide_issue()
        return can_view(2)
    end
    def can_level_up_user()
        return can_view(2) 
    end
    def can_editor_detail()

        if can_view(2)
            return true
        end
        return false
        #if !can_view(0)
        #    return false
        #end
        #detail = DataDetail.where(id: detail_id,is_report: false)[0]
        #if detail.post_id == current_user.id
        #    return true
        #end
        #ßreturn false
    end
    def can_editor_people()
        if can_view(2)
            return true
        end
        return false
    end
    def can_editor_media()
        if can_view(2)
            return true
        end
        return false
    end

    def can_report_detail()
        if can_view(0)
            return true
        end
        return false
    end
    def can_leave_comment()
        if can_view(0)
            return true
        end
        return false
    end
    def find_root_issue(issue_id)
        result = nil
        issuelist = DataIssue.all
        issue = issuelist.where(id: issue_id)[0]
        if issue.nil?
            return result
        end

        while issue.trunk_id != -1
            issue = issuelist.where(id: issue.trunk_id)[0]
        end

        result = issue
        return result
    end
end