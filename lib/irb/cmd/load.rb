# frozen_string_literal: false
#
#   load.rb -
#   	$Release Version: 0.9.6$
#   	$Revision$
#   	by Keiju ISHITSUKA(keiju@ruby-lang.org)
#
# --
#
#
#

require_relative "nop"
require_relative "../ext/loader"

module IRB
  # :stopdoc:

  module ExtendCommand
    class Load < Nop
      include IrbLoader

      category "IRB"
      description "Load a Ruby file."

      def execute(file_name, priv = nil)
        return irb_load(file_name, priv)
      end
    end

    class Require < Nop
      include IrbLoader

      category "IRB"
      description "Require a Ruby file."

      def execute(file_name)

        rex = Regexp.new("#{Regexp.quote(file_name)}(\.o|\.rb)?")
        return false if $".find{|f| f =~ rex}

        case file_name
        when /\.rb$/
          begin
            if irb_load(file_name)
              $".push file_name
              return true
            end
          rescue LoadError
          end
        when /\.(so|o|sl)$/
          return ruby_require(file_name)
        end

        begin
          irb_load(f = file_name + ".rb")
          $".push f
          return true
        rescue LoadError
          return ruby_require(file_name)
        end
      end
    end

    class Source < Nop
      include IrbLoader

      category "IRB"
      description "Loads a given file in the current session."

      def execute(file_name)
        source_file(file_name)
      end
    end
  end

  # :startdoc:
end
