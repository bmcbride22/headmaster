module ApplicationHelper
  def render_svg(name, options = {})
    options[:title] ||= name.underscore.humanize
    options[:aria] = true
    options[:nocomment] = true
    options[:class] = options.fetch(:styles, 'fill-current text-violet-700')

    file_name = "#{name}.svg"
    inline_svg_tag(file_name, options)
  end

  def is_active_nav_link?(link_path)
    if current_page?(link_path)
      'text-orange-100 bg-violet-800 group flex items-center px-2 py-2 text-base font-medium rounded-md'
    else
      'text-violet-100 hover:bg-violet-800 group flex items-center px-2 py-2 text-base font-medium rounded-md'
    end
  end

  def active_page?(page_name)
    controller_name == page_name
  end
end
