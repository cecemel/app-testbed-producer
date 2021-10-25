alias Acl.Accessibility.Always, as: AlwaysAccessible
alias Acl.GraphSpec.Constraint.Resource, as: ResourceConstraint
alias Acl.GraphSpec, as: GraphSpec
alias Acl.GroupSpec, as: GroupSpec
alias Acl.GroupSpec.GraphCleanup, as: GraphCleanup
alias Acl.GraphSpec.Constraint.Resource.AllPredicates, as: AllPredicates

defmodule Acl.UserGroups.Config do
  def user_groups do
    [
      # Something about books, for testing purposes
      %GroupSpec{
        name: "public",
        useage: [:write, :read],
        access: %AlwaysAccessible{},
        graphs: [ %GraphSpec{
                    graph:      "http://mu.semte.ch/graphs/public",
                    constraint: %ResourceConstraint{
                      source_graph:   "http://mu.semte.ch/application",
                      resource_types: [
                        "http://schema.org/Author",
                        "http://schema.org/Book",
                      ],
                      predicates: %AllPredicates{}
                    }
        } ]
      },

      # Public files (where stuff gets uploaded)
      %GroupSpec{
        name: "uploaded-files",
        useage: [:write, :read_for_write, :read],
        access: %AlwaysAccessible{},
        graphs: [ %GraphSpec{
                    graph: "http://mu.semte.ch/graphs/uploaded-files",
                    constraint: %ResourceConstraint{
                      resource_types: [
                        "http://www.semanticdesktop.org/ontologies/2007/03/22/nfo#FileDataObject",
                        "http://www.semanticdesktop.org/ontologies/2007/03/22/nfo#DataContainer"
                      ]
                    } } ] },

      # Readonly delta-files
      %GroupSpec{
        name: "delta-files",
        useage: [ :read ],
        access: %AlwaysAccessible{},
        graphs: [ %GraphSpec{
                    graph: "http://mu.semte.ch/graphs/json-diff-files",
                    constraint: %ResourceConstraint{
                      resource_types: [
                        "http://www.semanticdesktop.org/ontologies/2007/03/22/nfo#FileDataObject",
                        "http://www.semanticdesktop.org/ontologies/2007/03/22/nfo#DataContainer"
                      ]
                    } } ] },

      # CLEANUP
      #
      %GraphCleanup{
        originating_graph: "http://mu.semte.ch/application",
        useage: [:write],
        name: "clean"
      }
    ]
  end
end
