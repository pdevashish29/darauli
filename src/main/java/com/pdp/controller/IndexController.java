package com.pdp.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class IndexController {

	@RequestMapping("/welcome")
	public String welcome(){
		
		return "welcome";
	}
	
	
	@RequestMapping("/villages")
	public String villages(){
		
		return "village";
	}
}

