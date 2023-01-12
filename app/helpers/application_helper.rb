module ApplicationHelper
  def render_svg(name, options = {})
    options[:title] |= name.underscore.humanize
    options[:aria] = true
    options[:nocomment] = true
    options[:class] = options.fetch(styles, 'fill-current text-violet-700')

    file_name = "#{name}.svg"
    inline_svg_tag(file_name, options)
  end
end
