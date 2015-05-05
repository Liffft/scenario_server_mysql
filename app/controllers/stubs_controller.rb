class StubsController < ApplicationController
  def index
  	
  end
  def poll_log
  	@stubs = Stub.all.reverse
  end
  def clear_logs
  	begin
  		Stub.delete_all
  		render action: "index"
 	rescue Exception=>e
 		render :text => "An error has been occurred while deleting the stubs #{e.class.name}: #{e.message}"
 	end
  end
end