class GlobalResourcesController < GlobalController

  include SnippetSupport
  helper GlobalResourcesHelper

  layout nil

  def show
    render template_for(params[:snippet], params[:secure], params[:noscript], params[:cs], params[:legacystyle] ),  :locals => { user_nav: user_nav?(params), :tynt => params[:tynt], :show_js => params[:show_js] }
  end

  def index
    render '/global-nav/index', :layout=> 'core',  :locals => { user_nav: user_nav?(params), show_js: true }
  end

  def modern
    render '/global-nav/modern', :layout=> false,  :locals => { user_nav: true, show_js: true }
  end

  def legacy
    render '/global-nav/legacy', :layout=> false,  :locals => { user_nav: true, show_js: true }
  end

  def responsive
    render '/global-nav/responsive', :layout=> 'responsive', :locals => { tynt: false, show_js: true }
  end

  def minimal
    render '/global-nav/minimal', :layout=> 'minimal'
  end

  def show_nav_section(section)
    (defined?(section) && section == true) || (!defined? section)
  end
  helper_method :show_nav_section

end
