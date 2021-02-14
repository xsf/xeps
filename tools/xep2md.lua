#!/usr/bin/env lua5.3
-- XEP to Markdown converter
--

-- Inlined util.events from Prosody, you may wanna skip ahead ~160 lines
-- or so to the main script.
package.preload["util.events"] = (function()
-- Prosody IM
-- Copyright (C) 2008-2010 Matthew Wild
-- Copyright (C) 2008-2010 Waqas Hussain
--
-- This project is MIT/X11 licensed. Please see the
-- COPYING file in the source package for more information.
--


local pairs = pairs;
local t_insert = table.insert;
local t_remove = table.remove;
local t_sort = table.sort;
local setmetatable = setmetatable;
local next = next;

local _ENV = nil;

local function new()
	local handlers = {};
	local global_wrappers;
	local wrappers = {};
	local event_map = {};
	local function _rebuild_index(handlers, event)
		local _handlers = event_map[event];
		if not _handlers or next(_handlers) == nil then return; end
		local index = {};
		for handler in pairs(_handlers) do
			t_insert(index, handler);
		end
		t_sort(index, function(a, b) return _handlers[a] > _handlers[b]; end);
		handlers[event] = index;
		return index;
	end;
	setmetatable(handlers, { __index = _rebuild_index });
	local function add_handler(event, handler, priority)
		local map = event_map[event];
		if map then
			map[handler] = priority or 0;
		else
			map = {[handler] = priority or 0};
			event_map[event] = map;
		end
		handlers[event] = nil;
	end;
	local function remove_handler(event, handler)
		local map = event_map[event];
		if map then
			map[handler] = nil;
			handlers[event] = nil;
			if next(map) == nil then
				event_map[event] = nil;
			end
		end
	end;
	local function get_handlers(event)
		return handlers[event];
	end;
	local function add_handlers(handlers)
		for event, handler in pairs(handlers) do
			add_handler(event, handler);
		end
	end;
	local function remove_handlers(handlers)
		for event, handler in pairs(handlers) do
			remove_handler(event, handler);
		end
	end;
	local function _fire_event(event_name, event_data)
		local h = handlers[event_name];
		if h then
			for i=1,#h do
				local ret = h[i](event_data);
				if ret ~= nil then return ret; end
			end
		end
	end;
	local function fire_event(event_name, event_data)
		local w = wrappers[event_name] or global_wrappers;
		if w then
			local curr_wrapper = #w;
			local function c(event_name, event_data)
				curr_wrapper = curr_wrapper - 1;
				if curr_wrapper == 0 then
					if global_wrappers == nil or w == global_wrappers then
						return _fire_event(event_name, event_data);
					end
					w, curr_wrapper = global_wrappers, #global_wrappers;
					return w[curr_wrapper](c, event_name, event_data);
				else
					return w[curr_wrapper](c, event_name, event_data);
				end
			end
			return w[curr_wrapper](c, event_name, event_data);
		end
		return _fire_event(event_name, event_data);
	end
	local function add_wrapper(event_name, wrapper)
		local w;
		if event_name == false then
			w = global_wrappers;
			if not w then
				w = {};
				global_wrappers = w;
			end
		else
			w = wrappers[event_name];
			if not w then
				w = {};
				wrappers[event_name] = w;
			end
		end
		w[#w+1] = wrapper;
	end
	local function remove_wrapper(event_name, wrapper)
		local w;
		if event_name == false then
			w = global_wrappers;
		else
			w = wrappers[event_name];
		end
		if not w then return; end
		for i = #w, 1 do
			if w[i] == wrapper then
				t_remove(w, i);
			end
		end
		if #w == 0 then
			if event_name == nil then
				global_wrappers = nil;
			else
				wrappers[event_name] = nil;
			end
		end
	end
	return {
		add_handler = add_handler;
		remove_handler = remove_handler;
		add_handlers = add_handlers;
		remove_handlers = remove_handlers;
		get_handlers = get_handlers;
		wrappers = {
			add_handler = add_wrapper;
			remove_handler = remove_wrapper;
		};
		add_wrapper = add_wrapper;
		remove_wrapper = remove_wrapper;
		fire_event = fire_event;
		_handlers = handlers;
		_event_map = event_map;
	};
end

return {
	new = new;
};
end);

local lxp = require "lxp";
local lom = require "lxp.lom";
local events = require"util.events".new();

local handler = {};
local stack = {};

local meta = {};

local no_write = true;
local function output(...)
	if no_write then return end
	io.write(...);
end

local function print_empty_line()
	output("\n\n");
	return true;
end

local text_buf;

-- FIXME LuaExpat claims to not require this hack
local function CharacterDataDone()
	if text_buf then
		local text = table.concat(text_buf);
		if text ~= "" then
			events.fire_event("#text", { stack = stack, text = text });
		end
		text_buf = nil;
	end
end

function handler:StartElement(tagname, attr)
	CharacterDataDone();
	tagname = tagname:gsub("^([^\1]+)\1", "{%1}");
	table.insert(stack, tagname)
	events.fire_event(tagname, { stack = stack, attr = attr });
end

function handler:CharacterData(data)
	if text_buf then
		table.insert(text_buf, data)
	else
		text_buf = { data };
	end
end

function handler:EndElement()
	CharacterDataDone();
	events.fire_event(table.remove(stack) .. "/", { stack = stack });
end

-- Oh god oh god we're all gonna die!
local function escape_text(event)
	event.text = event.text:gsub("['&<>\"]", "\\%1"):gsub("^%s+", ""):gsub("%s+$", ""):gsub("%s+", " ");
end
events.add_handler("#text", escape_text, 1000);

events.add_handler("#text", function (event)
	local stack = event.stack;
	return events.fire_event(stack[#stack].."#text", event);
end, 10);

events.add_handler("#text", function (event)
	if event.text:find"%S" then
		output(event.text);
	end
	return true;
end);

local metafields = "title abstract number status lastcall type sig shortname"
for field in metafields:gmatch("%S+") do
	events.add_handler(field.."#text", function (event)
		meta[field] = event.text:match("%S.*%S");
		return true;
	end);
end

do
	local author;
	events.add_handler("author", function (event)
		author = { };
		return true;
	end);

	for _, field in pairs{"firstname", "surname", "email", "jid"} do
		events.add_handler(field.."#text", function (event) author[field] = event.text; return true; end);
	end

	events.add_handler("author/", function (event)
		if author.email then
			author = string.format("%s %s <%s>", author.firstname, author.surname, author.email);
		else
			author = string.format("%s %s", author.firstname, author.surname);
		end

		local authors = meta.author;
		if not authors then
			meta.author = { author; };
		else
			table.insert(authors, author);
		end

		author = nil;
		return true;
	end);
end

do
	local revision;
	for _, field in pairs{"version", "date", "initials"} do
		events.add_handler(field.."#text", function (event)
			if revision then
				revision[field] = event.text;
				return true;
			end
		end);
	end

	local function handle_remark(event)
		if revision and event.text and event.text:match("%S") then
			table.insert(revision.remark, event.text);
		end
	end

	events.add_handler("remark#text", handle_remark, 100);

	events.add_handler("remark", function (event)
		events.add_handler("p#text", handle_remark, 100);
	end);

	events.add_handler("remark/", function (event)
		events.remove_handler("p#text", handle_remark);
	end);

	events.add_handler("revision", function (event)
		revision = {remark={}};
		return true;
	end);

	local revisions = {};
	events.add_handler("revision/", function (event)
		table.insert(revisions, revision);
		meta.revision = revisions;
		revision = nil;
		return true;
	end);

end

events.add_handler("date#text", function (event)
	if meta and not meta.date then
		meta.date = event.text;
	end
end);

events.add_handler("spec#text", function (event)
	if not meta then return end

	local kind =  stack[#stack-1];
	if meta[kind] then
		table.insert(meta[kind], event.text);
	else
		meta[kind] = { event.text };
	end
end);

events.add_handler("header/", function (event)
	no_write = false;
	if next(meta) ~= nil then
		if meta.title and meta.number then
			meta.title = "XEP-"..meta.number..": "..meta.title;
		end
		if meta.author and #meta.author == 1 then
			meta.author = meta.author[1];
		end
		local have_yaml, yaml = pcall(require, "lyaml");
		if have_yaml and yaml.dump then
			output(yaml.dump({meta}));
		else
			print("% "..meta.title);
			if type(meta.author) == "table" then
				print("% "..table.concat(meta.author, "; "));
			elseif meta.author then
				print("% "..meta.author);
			else
				print("% ");
			end
			print("% "..meta.date);
		end
	end
	return true;
end);

for i = 1, 6 do
	events.add_handler("section"..i, function ()
		output("\n");
	end, 10);
	events.add_handler("section"..i.."/", function ()
		output("\n");
		return true;
	end, 10);

	events.add_handler("section"..i, function (event)
		assert(event.attr.topic, "no @topic");
		output(string.rep("#", i), " ", event.attr.topic);
		if event.attr.anchor and event.attr.anchor ~= "" then
			output(" {#", event.attr.anchor, "}\n")
		else
			output("\n");
		end
		return true;
	end);
end

events.add_handler("section1", function (event)
	output(event.attr.topic);
	if event.attr.anchor and event.attr.anchor ~= "" then
		output(" {#", event.attr.anchor, "}");
	end
	output("\n", string.rep("=", #event.attr.topic), "\n\n");
	return true;
end, 1);

events.add_handler("section2", function (event)
	output(event.attr.topic);
	if event.attr.anchor and event.attr.anchor ~= "" then
		output(" {#", event.attr.anchor, "}");
	end
	output("\n", string.rep("-", #event.attr.topic), "\n\n");
	return true;
end, 1);

local function normalize_whitespace(event)
	event.text = event.text:gsub("%s+", " ")
	-- event.text = event.text:match("^%s*(.-)%s*$")
end
events.add_handler("p#text", normalize_whitespace, 10);
events.add_handler("li#text", normalize_whitespace, 10);
events.add_handler("dt#text", normalize_whitespace, 10);
events.add_handler("dd#text", normalize_whitespace, 10);

local example_count = 1;

events.add_handler("example", function (event)
	output("\n#### Example ", example_count, ". ");
	if event.attr.caption then
		output(event.attr.caption, " ")
	end
	output("{#example-", example_count, " .unnumbered}\n\n")
	example_count = example_count + 1;
	output("``` {.xml .example}\n");
	events.remove_handler("#text", escape_text);
end);

events.add_handler("example#text", function (event)
	local example_text = event.text:match("^%s*(.-)%s*$");
	output(example_text, "\n");
	return true;
end);

events.add_handler("example/", function ()
	events.add_handler("#text", escape_text, 1000);
	output("```\n\n");
	return true;
end);

events.add_handler("note", function (event)
	output(" ^[");
	return true;
end);

events.add_handler("note/", function (event)
	output("]");
	return true;
end);

-- TODO magically import citation data
events.add_handler("cite#text", function (event)
	output("**", event.text, "**");
	if meta.references then
		local refid = event.text:gsub("%W", ""):lower();
		if meta.references[refid] then
			output("[@", refid, "]");
		end
	end
	return true;
end);

local url;
events.add_handler("link", function (event)
	url = event.attr.url;
	if url then
		output("[");
	end
	return true;
end);

events.add_handler("link/", function (event)
	if url then
		output("](", url, ")");
		url = nil;
	end
	return true;
end);


local list_depth, list_type = 0, "ul";
events.add_handler("ul", function ()
	list_depth = list_depth + 1;
	list_type = "ul";
end);

events.add_handler("ul/", function (event)
	local stack = event.stack;
	list_depth = list_depth - 1;
	for i = #stack, 1, -1 do
		local element = stack[i]
		if element == "ul" or element == "ol" then
			list_type = element;
			break;
		end
	end
	return true;
end);

events.add_handler("li", function (event)
	for i = 2, list_depth do
		output("    ");
	end
	if list_type == "ul" then
		output("-   ");
	elseif list_type == "ul" then
		output("#.  ");
	end
	return true;
end);

events.add_handler("li#text", function (event)
	local text = event.text:gsub("%s+", " ");
	output(text);
	return true;
end);

events.add_handler("dd#text", function (event)
	output("\n:   ");
end);

events.add_handler("li/", print_empty_line, 1);
events.add_handler("ul", print_empty_line, 1);
events.add_handler("ul/", print_empty_line, 1);
events.add_handler("ol", print_empty_line, 1);
events.add_handler("ol/", print_empty_line, 1);
events.add_handler("p/", print_empty_line, 1);
events.add_handler("dd/", print_empty_line, 1);

local function printcell(event)
	output("|");
end
events.add_handler("th", printcell, 1);
events.add_handler("td", printcell, 1);
events.add_handler("tr/", printcell, 3);
events.add_handler("tr", function () output("  ") end, 1);
events.add_handler("tr/", function () output("\n") end, 1);

local th;
events.add_handler("table", function () th = 0; end);
events.add_handler("table/", function () th = 0; end);
events.add_handler("th", function () if th then th = th + 1; end end);
events.add_handler("tr/", function () if th then  output("\n");output("  |"); output(string.rep("---|", th)); th = nil end end, 2);

-- Non-example code blocks, like schemas
events.add_handler("code", function (event)
	output("```xml\n");
	events.remove_handler("#text", escape_text);
	return true;
end);

events.add_handler("code#text", function (event)
	local example_text = event.text:match("^%s*(.-)%s*$");
	output(example_text, "\n");
	return true;
end);

events.add_handler("code/", function ()
	events.add_handler("#text", escape_text, 1000);
	output("```\n\n");
	return true;
end);

if meta.references then
	events.add_handler("xep/", function ()
		output("\n\n# References {#references}\n\n");
	end);
end

if arg[1] == "--debug" then
	events.add_wrapper(false, function (fire_event, event_name, event_data)
		io.stderr:write("D: "..event_name.."\n");
		io.stderr:write("D: /"..table.concat(event_data.stack, "/").."\n");
		return fire_event(event_name, event_data);
	end);
	setmetatable(handler, {
		__index = function (_, missinghandler)
			io.stderr:write("D: Missing handler: "..missinghandler.."\n");
			return function (parser, ...)
				io.stderr:write("D: ", missinghandler, "(");
				local count = select('#', ...);
				for i = 1, count do
					local arg = select(i, ...);
					local arg_t = type(arg);
					io.stderr:write(arg_t, ":");
					if arg_t == "string" then
						io.stderr:write(string.format("%q", arg));
					else
						io.stderr:write(tostring(arg));
					end
					if i ~= count then
						io.stderr:write(", ");
					end
				end
				io.stderr:write(")\n");
				return "";
			end;
		end;
	});
end

local parser = lxp.new(handler, "\1");
parser:setbase(".");
local function chunks(file, size)
	return function ()
		return file:read(size);
	end
end

for chunk in chunks(io.stdin, 4096) do
	local ok, err, line, col = parser:parse(chunk);
	if not ok then
		io.stderr:write("E: "..err.." on line "..line..", col "..col.."\n");
		os.exit(1);
	end
end

parser:close();
