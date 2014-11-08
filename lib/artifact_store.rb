class ArtifactStore
  def initialize(params)
    @db = params[:db]
  end

  def store_and_get_deltas(name_and_titles)
    known_titles_from(name_and_titles.name) do |known_titles|
      difference_of(name_and_titles.titles, known_titles) do |diff|
        @db.save_titles(name_and_titles.titles) unless diff.empty?
      end
    end
  end

  private

  def difference_of(as, bs)
    result = as - bs
    yield(result)
    result
  end

  def known_titles_from(key)
    yield(@db.find_titles(key))
  end
end
