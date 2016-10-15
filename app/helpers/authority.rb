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
    def can_editor_issue(levelLimit,issue_id)

        if current_user.nil?
            return false
        end
        if current_user.level.nil?
            return false
        end
        if current_user.level < levelLimit
            return false
        end
        if current_user.level > levelLimit
            return true
        end

        if current_user.own.nil?
            return false
        end
        if current_user.own.split(',').include?(find_root_issue(issue_id).id.to_s)
            return true
        end

        return false
    end
    def can_editor_detail(detail_id)

        if current_user.nil?
            return false
        end
        if current_user.level.nil?
            return false
        end
        if current_user.level >= 2
            return true
        end 
        detail = DataDetail.where(id: detail_id,is_report: false)[0]
        if detail.post_id == current_user.id
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