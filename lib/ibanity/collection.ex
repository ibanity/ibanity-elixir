defmodule Ibanity.Collection do
  @moduledoc """
  Container for collection of resources results.
  """

  alias Ibanity.Client

  defstruct items: [],
            page_limit: nil,
            page_number: nil,
            page_size: nil,
            total_entries: nil,
            total_pages: nil,
            before_cursor: nil,
            after_cursor: nil,
            first_link: nil,
            next_link: nil,
            previous_link: nil,
            last_link: nil,
            latest_synchronization: nil,
            synchronized_at: nil

  def new(items, paging, links, synchronized_at \\ nil, latest_synchronization \\ nil) do
    %__MODULE__{
      items: items,
      page_limit: paging["limit"],
      before_cursor: paging["before"],
      after_cursor: paging["after"],
      total_entries: paging["totalEntries"],
      total_pages: paging["totalPages"],
      page_number: paging["pageNumber"],
      page_size: paging["pageSize"],
      first_link: links["first"],
      next_link: links["next"],
      previous_link: links["prev"],
      last_link: links["last"],
      synchronized_at: synchronized_at,
      latest_synchronization: latest_synchronization
    }
  end

  @doc """
  Fetches the next results.

  Returns `{:ok, collection}` if successful, `nil` if there's no more elements to fetch, `{:error, reason}` otherwise.
  """
  def next(%__MODULE__{} = collection, application \\ :default) do
    get_link(collection, :next_link, application)
  end

  @doc """
  Fetches the previous results

  Returns `{:ok, collection}` if successful, `nil` if there's no previous elements to fetch, `{:error, reason}` otherwise.
  """
  def previous(%__MODULE__{} = collection, application \\ :default) do
    get_link(collection, :previous_link, application)
  end

  @doc """
  Fetches the first results

  Returns `{:ok, collection}` if successful, `{:error, reason}` otherwise.
  """
  def first(%__MODULE__{} = collection, application \\ :default) do
    get_link(collection, :first_link, application)
  end

  defp get_link(collection, link, application) do
    if Map.fetch!(collection, link),
      do: collection |> Map.fetch!(link) |> Client.get(application),
      else: nil
  end
end
