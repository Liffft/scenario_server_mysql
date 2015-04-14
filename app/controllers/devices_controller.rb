require 'socket' 
require 'cgi'
class DevicesController < ApplicationController

skip_before_filter :verify_authenticity_token

	def respond_to_app_client
		begin
			remote_ip = request.remote_ip
			if remote_ip=="::1"
				ip_address = local_ip
			else
				ip_address = remote_ip
			end
			url = URI.parse(request.url)
			sorted_string = Hash[request.query_parameters.sort]
			query = sorted_string.to_query
			if query.to_s.strip.length != 0
				query = "?"<<query
			end
			received_path = "/#{params[:path]}#{query}"
			@device = Device.find_by(:device_ip=>ip_address)
			@route = @device.scenario.routes.find_by(:path=>received_path,:route_type=>request.method)
			if @route.blank?
				render :json => { :status => '404', :message => 'Not Found'}, :status => 404
			else
				render json: @route.fixture, :status => 200
			end
		rescue =>e
			logger.error "An error has been occurred in respond_to_CMA_client #{e.class.name} : #{e.message}"
			render :json => { :status => '404', :message => 'Not Found'}, :status => 404
		end	
	end

	def set_scenario  
		begin
		   @scenario = Scenario.find_by(:scenario_name=>params[:scenario_name])
		   if @scenario.blank?
		   		logger.debug "Invalid scenario: #{params[:scenario_name]}"
			    render :json => { :status => '404', :message => 'Not Found'}, :status => 404
			else
				@device = Device.find_or_initialize_by(:device_ip=>params[:device_ip])
		  		@device.update(scenario: @scenario)
			  	render :json => { :status => 'Ok', :message => 'Received'}, :status => 200 
		    end
		    rescue =>e
				logger.error "An error has been occurred in Set_Scenario #{e.class.name} : #{e.message}"
				render :json => { :status => '404', :message => 'Not Found'}, :status => 404
			end	
	end

	def local_ip
	  orig, Socket.do_not_reverse_lookup = Socket.do_not_reverse_lookup, true  # turn off reverse DNS resolution temporarily
	  UDPSocket.open do |s|
	    s.connect '64.233.187.99', 1
	    s.addr.last
	  end
	ensure
	  Socket.do_not_reverse_lookup = orig
	end
end

