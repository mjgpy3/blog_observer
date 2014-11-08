RetrievalDetails = Struct.new(:link, :xpath)
BlogNameAndTitles = Struct.new(:name, :titles)

class UpdateAnalyzer
  def initialize(params)
    @retriever, @artifacts = params.values_at(:retriever, :artifacts)
    @blogs = params[:config].blogs
  end

  def updates
    @blogs.reduce({}) do |hsh, blog_details|
      hsh.merge(name_to_deltas(blog_details))
    end
  end

  private

  def name_to_deltas(details)
    find_deltas_and_update_artifact_store!(details)
    @deltas.empty? ? {} : {
      details['name'] => {
        deltas: @deltas,
      }
    }
  end

  private

  def find_deltas_and_update_artifact_store!(details)
    @deltas = @artifacts.store_and_get_deltas(
      BlogNameAndTitles.new(
        details['name'],
        retrieve_title_list(details)
      )
    )
  end

  def retrieve_title_list(details)
    @retriever.retrieve(
      RetrievalDetails.new(details.values_at('link', 'title_xpath'))
    )
  end
end
