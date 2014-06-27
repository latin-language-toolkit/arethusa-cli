require 'thor'

module ArethusaPluginGenerator
  class CLI < Thor
    include Thor::Actions

    attr_reader :namespace, :name

    def self.source_root
      File.dirname(__FILE__)
    end

    desc 'new', 'Creates a new Arethusa plugin skeleton'
    method_option :namespace, aliases: '-n',
      desc: 'Namespace of the new plugin'
    def new(name)
      @name = name
      @namespace = options[:namespace] || 'arethusa'

      create_directories
      create_files

      puts
      say_status(:success, "Created #{namespaced_name}")
      give_conf_instructions
    end

    no_commands do
      def namespaced_name
        [namespace, name].compact.join('.')
      end

      DIRECTORIES = %w{ plugin_dir template_dir }
      def create_directories
        DIRECTORIES.each { |dir| empty_directory(send(dir)) }
      end

      def create_files
        create_service
        create_html_template
      end

      def create_service
        template('templates/service.tt', plugin_dir("#{name}.js"))
      end

        create_module
        create_module
      def create_html_template
        template('templates/html_template.tt', html_template_file)
      end
      def create_module
        template('templates/module.tt', js_dir("#{namespaced_name}.js"))
      end


      def give_conf_instructions
      def create_module
        template('templates/module.tt', js_dir("#{namespaced_name}.js"))
      end

        text = <<-EOF
Now add your new #{name} plugin to a conf file and add a configuration for it.
It could look like this:

 "#{name}" : {
   "name" : "#{name}",
   "template" : #{html_template_file.slice(/template.*/)}
 }
        EOF
        puts text.lines.map { |line| "\t#{line}" }.join
      end

      def plugin_dir(file = '')
        File.join(js_dir, namespaced_name, file)
      end

      def template_dir(file = '')
        File.join(temp_dir, namespaced_name, file)
      end

      def html_template_file
        template_dir("#{name}.html")
      end

      def js_dir
        File.join(destination_root, 'app/js')
      end

      def temp_dir
        File.join(destination_root, 'app/templates')
      end
    end
  end
end
