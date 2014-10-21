# -*- coding: utf-8 -*-
require File.expand_path(File.dirname(__FILE__) + "/../../config/environment")

namespace :app do
  namespace :mail do
    desc 'Send mail reminder for divorce complaint.'
    task :send_reminder => :environment do
      MailReminder.all.each do |mail|
        day = (Time.now.utc.beginning_of_day - mail.created_at.utc.beginning_of_day) / 86400
        if mail.reminder_type == 'after_download' && (day == 20 || day == 60 || day == 80)
          user = User.find(mail.user_id)
          document = user.documents.where(:template_name => Document::DIVORCE_COMPLAINT).first
          MailForm.reminder_after_download_divorce_complaint(user, day, document).deliver
        elsif mail.reminder_type == 'after_finished' && (day == 10 || day == 20)
          user = User.find(mail.user_id)
          document = user.documents.where(:template_name => Document::DIVORCE_COMPLAINT).first
          MailForm.reminder_after_finished_divorce_complaint(user, day, document).deliver
        end
      end
    end
  end
end