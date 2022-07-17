class TestsController < Simpler::Controller

  def index
    @time = Time.now
    status 201
    headers['X-Simpler-Header'] = 'custom_header'

    # render "tests/list"
     # render plain: "HEEELLOOOOO!!!"
  end

  def create;
    render plain: "Params: #{params}"
  end

  def show
    render plain: "Params: #{params}"
  end

end
