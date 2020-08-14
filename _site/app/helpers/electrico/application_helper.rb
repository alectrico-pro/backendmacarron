module Electrico
  module ApplicationHelper

=begin
  #In a controller, request.env['HTTP_HOST'] will contain the host part of the request that came in, so you could create a helper method to return a properly formatted "base url" doing something like this:

  def site_root_url
    if request.env['HTTPS'] == 'on'
      proto = 'https'
    else
      proto = 'http'
    end
    "#{proto}://#{request.env['HTTP_HOST']}"
  end


  <%= link_to('View', request.host + "#" +group_url(136, :only_path => true)) %>
  <%= link_to('View', request.protocol + request.host + "#" +group_url(136, :only_path => true)) %>
  <%= link_to('View', request.protocol + request.host_with_port + "#" +group_url(136, :only_path => true)) 



    hack:

    host = group_url(136).gsub(/#{group_url(136, :only_path => true)}/, "")

    or

    url  = group_url(136)
    path = group_path(136)
    host = url.gsub(/#{path}/, "")
=end

  #ttp://stackoverflow.com/questions/17662089/form-for-error-messages-in-rails-4
  def form_errors_for(object=nil)
    render('shared/form_errors', object: object) unless object.blank?
  end

  #inally, place the helper at the start of each form:

  # <%= form_for(@model) do |f| %>
  # <%= form_errors_for @model %>

  #   <%# ... form fields ... %>
  #   <% end %>

  def items_cesta()
   @total_cesta_cables = 0
   @items_cesta = 0
   CestaCable.all.each{|c| t=TipoMaterial.find_by_id(c.tipo_material_id);c.cantidad =1 unless !c.cantidad.blank?; suma= t.costo * c.cantidad unless t.nil?; @total_cesta_cables += suma unless t.nil?; @items_cesta += 1 unless t.nil?}

   return @items_cesta
  end

  def formatted_number(number)
    digits = number.gsub(/\D/, '').split(//)

    if (digits.length == 11 and digits[0] == '1')
      # Strip leading 1
      digits.shift
    end

    if (digits.length == 10)
      '(%s) %s-%s' % [ digits[0,3], digits[3,3], digits[6,4] ]
    end



    if (digits.length == 9)
      '(%s) %s-%s' % [ digits[1,1], digits[2,4], digits[6,4] ]
    end

  end



  #me lo encontre y está interesante 
  def http_download_uri(uri, filename)
    pbar = nil
    begin
      uri.open(
	    allow_redirections: :all,
	    read_timeout: 500,
	    content_length_proc: lambda { |t|
	    if t && 0 < t
	      pbar = ProgressBar.new("...", t)
	      pbar.file_transfer_mode
	    end
	    },
	    progress_proc: lambda {|s|
	      pbar.set s if pbar
	    }) do |file|
	open filename, 'w' do |io|
	  file.each_line do |line|
	    io.write line
	  end
	end
      end
    rescue => e
      case e
      when OpenURI::HTTPError
	puts "HTTPError: '#{e}' for #{uri}"
      when Zlib::BufError
	puts "Zlib::BufError: '#{e}' for #{uri}"
      else
	raise e
      end
    end
  end
    def link_to_remove_fields(name,f)
      f.hidden_field(:_destroy) + link_to_function(name, "remove_fields(this)")
    end
   
    def namespace_for(association)
	url_for(:controller => association)
    end

    def link_to_add_fields(name, f, association)

#     raise f.object.class.reflect_on_association(association).klass.inspect
     begin
       new_object = f.object.class.reflect_on_association(association).klass.new
     rescue
       raise "Ocurrió un error en link_add_fields con la associacion #{association.inspect}"
     end

     fields = f.fields_for( association, new_object, :child_index => "new_#{association}") do |builder|
         render(url_for(:controller => new_object.class.name.underscore.pluralize) + "/fields", :f => builder)
     end
     link_to_function(name, "add_fields(this, \"#{association}\",\"#{escape_javascript(fields)}\")")
    end

    def valid_signing(user)
      fill_in "Email", with: user.email
      fill_in "Password", with: user.password
      click_button "Cree mi cuenta!"
    end

    def full_title(page_title)
      base_title = "Instalador Eléctrico Autorizado"
      if page_title.empty? then
	base_title
      else
	"#{base_title} | #{page_title}"
      end
    end
  end
end
