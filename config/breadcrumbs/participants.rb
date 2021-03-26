crumb :participants do |booking|
  link I18n.t("navigation.participants"), booking_participants_path(booking)
  parent :booking, booking
end

crumb :participant do |booking, participant|
  link("#{participant.first_name} #{participant.last_name}",
       edit_booking_participant_path(booking, participant))
  parent :participants, booking
end

crumb :participant_edit do |booking, participant|
  link I18n.t("edit"), "#"
  parent :participant, booking, participant
end
