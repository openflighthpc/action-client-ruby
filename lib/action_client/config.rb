# frozen_string_literal: true

#==============================================================================
# Copyright (C) 2020-present Alces Flight Ltd.
#
# This file is part of Action Client.
#
# This program and the accompanying materials are made available under
# the terms of the Eclipse Public License 2.0 which is available at
# <https://www.eclipse.org/legal/epl-2.0>, or alternative license
# terms made available by Alces Flight Ltd - please direct inquiries
# about licensing to licensing@alces-flight.com.
#
# Action Client is distributed in the hope that it will be useful, but
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, EITHER EXPRESS OR
# IMPLIED INCLUDING, WITHOUT LIMITATION, ANY WARRANTIES OR CONDITIONS
# OF TITLE, NON-INFRINGEMENT, MERCHANTABILITY OR FITNESS FOR A
# PARTICULAR PURPOSE. See the Eclipse Public License 2.0 for more
# details.
#
# You should have received a copy of the Eclipse Public License 2.0
# along with Action Client. If not, see:
#
#  https://opensource.org/licenses/EPL-2.0
#
# For more information on Action Client, please visit:
# https://github.com/openflighthpc/action-client-ruby
#===============================================================================

require 'yaml'
require 'hashie'

module ActionClient
  class Config < Hashie::Trash
    module Cache
      class << self
        def cache
          @cache ||=  begin
            if File.exists? path
              Config.new(YAML.load(File.read(path), symbolize_names: true))
            else
              $stderr.puts <<~ERROR.chomp
                ERROR: The configuration file does not exist: #{path}
              ERROR
              exit 1
            end
          end
        end

        def path
          File.expand_path('../../etc/config.yaml', __dir__)
        end

        delegate_missing_to :cache
      end
    end

    include Hashie::Extensions::IgnoreUndeclared

    property :base_url
    property :jwt_token, default: ''
    property :debug

    property :hide_print_flags
    property :print_stdout, default: true
    property :print_stderr, default: true
    property :verify_ssl, default: true

    [:debug, :hide_print_flags, :verify_ssl].each do |m|
      define_method("#{m}?") { public_send(m) ? true : false }
    end
  end
end

