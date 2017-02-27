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
    def been_disable(disable_level)
        if current_user.nil?
            return true
        end
        if current_user.level.nil?
            return true
        end
        if current_user.level >= 1
            return false 
        end
        if current_user.other.nil? || current_user.other.empty? || current_user.other == "0"
            return false
        end
        if current_user.other.to_i >= disable_level
            return true
        else
            return false
        end
        return false
    end
    def can_add_issue()
        return !been_disable(2) && can_view(0)
    end
    def can_add_detail()
        return !been_disable(1) && can_view(0)
    end
    def can_add_comment()
        return !been_disable(2) && can_view(0)
    end
    def can_editor_media()
        return can_view(2)
    end
    def can_editor_issue()
        if can_view(2)
            return true
        else
            return false
        end
    end
    def can_editor_user(user_id)
        if can_view(2)
            return true
        elsif !current_user.nil? && current_user.id == user_id
            return true
        else
            return false
        end
                
    end
    def can_like()
        return !been_disable(1) && can_view(0)
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
        if !can_add_detail()
            return false
        end
        detail = DataDetail.where(id: detail_id,is_report: false)[0]
        if detail.post_id == current_user.id
            return true
        end
        return false
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
        if !been_disable(1) && can_view(0)
            return true
        end
        return false
    end
    def can_leave_comment()
        if !been_disable(2) && can_view(0)
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