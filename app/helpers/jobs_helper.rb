module JobsHelper
  # 判断是否隐藏职缺 #
  def render_job_status(job)
      if job.is_hidden
        content_tag(:span, "", :class => "fa fa-lock fa-lg",)
      else
        content_tag(:span, "", :class => "fa fa-globe fa-lg")
      end
  end

  def render_highlight_content(job,query_string)
    excerpt_cont = excerpt(job.title, query_string, radius: 500)
    highlight(excerpt_cont, query_string)
  end

  # 判断是否投递过简历 #
  def render_job_resumes(job)
    if job.resumes.count > 0
      "fa fa-envelope-open-o"
    else
      "fa fa-envelope-o"
    end
  end
  # 判断是否有人收藏 #
  def render_job_favorites(job)
    if job.job_favorites.count > 0
      "fa fa-heart"
    else
      "fa fa-heart-o"
    end
  end

end
