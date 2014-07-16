# Kill breadcrumbs entirely since AA currently doesn't correctly handle linked
# to nested resources.
module ActiveAdmin
  module ViewHelpers
    module BreadcrumbHelper
      def breadcrumb_links(path = nil)
        []
      end
    end
  end
end