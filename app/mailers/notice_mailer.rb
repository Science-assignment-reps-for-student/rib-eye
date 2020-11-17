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
      return Team.find_by_leader_id_and_assignment_id(target.id,
                                                      assignment.id)
                 .students.each do |student|
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
