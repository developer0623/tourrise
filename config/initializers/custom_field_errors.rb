ActionView::Base.field_error_proc = proc do |html_tag, instance_tag|
  match = html_tag.to_s.match(/class\s*=\s*"([^"]*)"/)
  return html_tag unless match[1]

  html_tag
    .to_s
    .gsub(match[0], "class=\"#{match[1]} Input--invalid\"")
    .html_safe
end
