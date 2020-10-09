defimpl Phoenix.Param, for: Rumbl.Multimedia.Video do
  # I don't know exactly why works,
  # what i do know it need the id as the first part of the url
  # So it's basically ignoring the rest of the string,
  # this allow the url to change n times and still not
  # break compatibility with the old ones.
  # see: https://hashrocket.com/blog/posts/titled-url-slugs-in-phoenix
  def to_param(%{slug: slug, id: id}) do
    "#{id}-#{slug}"
  end
end
