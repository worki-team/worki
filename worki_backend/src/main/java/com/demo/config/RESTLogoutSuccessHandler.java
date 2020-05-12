package com.demo.config;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.security.core.Authentication;
import org.springframework.security.web.authentication.logout.SimpleUrlLogoutSuccessHandler;
import org.springframework.stereotype.Component;

@Component
public class RESTLogoutSuccessHandler extends SimpleUrlLogoutSuccessHandler {

	// Just for setting the default target URL
	public RESTLogoutSuccessHandler() {
		this.setDefaultTargetUrl("/");
	}

	@Override
	public void onLogoutSuccess(HttpServletRequest request, HttpServletResponse response, Authentication authentication)
			throws IOException, ServletException {

		String targetUrl = determineTargetUrl(request, response);

		if (response.isCommitted()) {
			logger.debug("Response has already been committed. Unable to redirect to " + targetUrl);
			return ;
		}
	}
}