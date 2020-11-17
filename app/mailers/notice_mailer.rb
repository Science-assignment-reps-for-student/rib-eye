class NoticeMailer < ApplicationMailer
  def submission(target, assignment)
    @name = target.name
    @title = assignment.title
    @type = assignment.type_korean
    @subject = "[제출 알림][#{@type}]#{@title}"
    @is_late = if assignment.files.last.is_late
                 '지각'
               else
                 '제출'
               end

    if assignment.type == 'TEAM'
      return target.team(assignment.id).students do |student|
               mail(from: 'notify@scarfs.hs.kr',
                    to: student.email,
                    subject: @subject,
                    content_type: 'text/html')
             end
    end

    mail(from: 'notify@scarfs.hs.kr',
         to: target.email,
         subject: @subject,
         content_type: 'text/html')
  end
end
