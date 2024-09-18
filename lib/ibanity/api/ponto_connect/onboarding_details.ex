defmodule Ibanity.PontoConnect.OnboardingDetails do
  @moduledoc """
  [Onboarding Detials](https://documentation.ibanity.com/xs2a/api#onboarding-details) API wrapper

  #{Ibanity.PontoConnect.common_docs!(:client_token)}
  """

  use Ibanity.Resource

  @api_schema_path ["ponto-connect", "onboardingDetails"]

  defstruct [
    :id,
    :email,
    :first_name,
    :last_name,
    :address_city,
    :address_country,
    :address_postal_code,
    :address_street_address,
    :enterprise_number,
    :vat_number,
    :phone_number,
    :initial_financial_institution_id,
    :organization_name
  ]

  alias Ibanity.PontoConnect

  @doc """
  [Creates Onboarding Details](https://documentation.ibanity.com/ponto-connect/api#create-onboarding-details).

  Returns `{:ok, %__MODULE__{}}` if successful, `{:error, reason}` otherwise.

  ## Example

  Attributes

      iex> attributes = [
      ...>   email: "jsmith@example.com",
      ...>   first_name: "Jo",
      ...>   last_name: "Smith",
      ...>   organization_name: "Smith Ltd",
      ...>   enterprise_number: "0999999999",
      ...>   vat_number: "BE0999999999",
      ...>   address_street_address: "123 Main St",
      ...>   address_country: "BE",
      ...>   address_postal_code: "1000",
      ...>   address_city: "Brussels",
      ...>   phone_number: "+32484000000",
      ...>   initial_financial_institution_id: "953934eb-229a-4fd2-8675-07794078cc7d"
      ...> ]

  Use attributes:

      iex> Ibanity.PontoConnect.OnboardingDetails.create(client_token, attributes)
      {:ok, %Ibanity.PontoConnect.OnboardingDetails{id: "343e64e5-4882-4559-96d0-221c398288f3"}}

      iex> request = Request.customer_access_token(client_token)
      iex> Ibanity.PontoConnect.OnboardingDetails.create(request, attributes)
      {:ok, %Ibanity.PontoConnect.OnboardingDetails{id: "343e64e5-4882-4559-96d0-221c398288f3"}}
  """
  def create(%PontoConnect.Token{} = request_or_token, attrs) do
    request_or_token
    |> Request.customer_access_token()
    |> create(attrs)
  end

  def create(%Request{customer_access_token: token} = request_or_token, attrs)
      when not is_nil(token) and is_list(attrs) do
    request_or_token
    |> Request.attributes(attrs)
    |> create()
  end

  def create(other, _attrs) do
    raise ArgumentError,
      message: PontoConnect.token_argument_error_msg("OnboardingDetails", other)
  end

  @doc """
  Same as `create/2`, but `:attributes`, `:account_id`, and `:customer_access_token` must be set in request.

  ## Examples

  Set id and customer_access_token to request a BulkPayment

      iex> %PontoConnect.Token{}
      ...> |> Request.customer_access_token()
      ...> |> Request.attributes(attributes)
      ...> |> PontoConnect.BulkPayment.create()
      {:ok, %PontoConnect.BulkPayment{id: "343e64e5-4882-4559-96d0-221c398288f3"}}
  """
  def create(%Request{} = request) do
    request
    |> Request.id("")
    |> Client.execute(:post, @api_schema_path, __MODULE__)
  end

  @doc false
  def key_mapping do
    [
      id: {["id"], :string},
      email: {["attributes", "email"], :string},
      first_name: {["attributes", "firstName"], :string},
      last_name: {["attributes", "lastName"], :string},
      address_city: {["attributes", "addressCity"], :string},
      address_country: {["attributes", "addressCountry"], :string},
      address_postal_code: {["attributes", "addressPostalCode"], :string},
      address_street_address: {["attributes", "addressStreetAddress"], :string},
      enterprise_number: {["attributes", "enterpriseNumber"], :string},
      vat_number: {["attributes", "vatNumber"], :string},
      phone_number: {["attributes", "phoneNumber"], :string},
      initial_financial_institution_id:
        {["attributes", "initialFinancialInstitutionId"], :string},
      organization_name: {["attributes", "organizationName"], :string}
    ]
  end
end
