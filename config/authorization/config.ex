alias Acl.Accessibility.Always, as: AlwaysAccessible
alias Acl.GraphSpec.Constraint.Resource, as: ResourceConstraint
alias Acl.GraphSpec, as: GraphSpec
alias Acl.GroupSpec, as: GroupSpec
alias Acl.GroupSpec.GraphCleanup, as: GraphCleanup

defmodule Acl.UserGroups.Config do
  def user_groups do
    [
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
