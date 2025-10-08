-- XEP output format for pandoc
--
-- Based on the pandoc sample.lua HTML writer
--
-- Invoke with: pandoc -t 2xep.lua
--
-- Based on `data/sample.lua` from pandoc.
--
-- Modifications released under the MIT license.
-- Copyright (C) 2021 Kim Alvefur

-- luacheck: globals Blocksep Doc Space SoftBreak Str LineBreak Emph Strong Subscript Superscript SmallCaps Strikeout
-- luacheck: globals Link Image Code InlineMath DisplayMath SingleQuoted DoubleQuoted Note Span RawInline Cite Plain
-- luacheck: globals Para Header BlockQuote HorizontalRule LineBlock CodeBlock BulletList OrderedList DefinitionList
-- luacheck: globals CaptionedImage Table RawBlock Div

local escape_table = { ["'"] = "&apos;", ["\""] = "&quot;", ["<"] = "&lt;", [">"] = "&gt;", ["&"] = "&amp;" };
local function escape(s, in_attribute)
  return (string.gsub(s, in_attribute and "['&<>\"]" or "[&<>]", escape_table));
end

local sectionstack = {};

-- Helper function to convert an attributes table into
-- a string that can be put into HTML tags.
local function attributes(attr)
  local attr_table = {}
  for x,y in pairs(attr) do
    if y and y ~= "" then
      table.insert(attr_table, ' ' .. x .. '="' .. escape(y,true) .. '"')
    end
  end
  return table.concat(attr_table)
end

-- Blocksep is used to separate block elements.
function Blocksep()
  return "\n\n"
end

-- This function is called once for the whole document. Parameters:
-- body is a string, metadata is a table, variables is a table.
-- This gives you a fragment.  You could use the metadata table to
-- fill variables in a custom lua template.  Or, pass `--template=...`
-- to pandoc, and pandoc will add do the template processing as
-- usual.
function Doc(body, metadata, variables)
  local buffer = { [[
<?xml version='1.0' encoding='UTF-8'?>
<!DOCTYPE xep SYSTEM 'xep.dtd' [
  <!ENTITY % ents SYSTEM 'xep.ent'>
%ents;
]>
<?xml-stylesheet type='text/xsl' href='xep.xsl'?>
<xep><header>]]
	}
  local function add(s)
    table.insert(buffer, s)
  end
	local header_schema = [[
		(title , abstract , legal , number , status , lastcall* ,
		interim* , type , sig , approver* , dependencies , supersedes ,
		supersededby , shortname , schemaloc* , registry? , discuss? ,
		expires? , author+ , revision+ , councilnote?)
	]];
	for field, r in string.gmatch(header_schema, "(%w+)(%p?)") do
		local repeated = r ~= "";
		local v = metadata[field] or variables[field];
		if not v then
			if field == "legal" then
				add("&LEGALNOTICE;");
				goto next;
			elseif field == "supersedes" or field == "supersededby" or field == "dependencies" then
				add(("<%s/>"):format(field));
				goto next;
			elseif r ~= "*" and r ~= "?" then
				io.stderr:write(string.format("Missing REQUIRED metadata field '%s'\n", field));
				goto next;
			else
				io.stderr:write(string.format("Missing optional metadata field '%s'\n", field));
				goto next;
			end
		end
		if field == "number" then
			assert(tonumber(v) or v == "xxxx", "Invalid XEP number");
			if v ~= "xxxx" then
				v = string.format("%04d", tonumber(v));
			end
		end
		if type(v) == "table" then
			if not repeated then
				-- Field is not repeated, so a single element
				-- contains all children
				add(string.format("<%s>", field));
			end

			for sk, sv in pairs(v) do
				if r ~= "" then
					-- This field is repeated for each child
					add(string.format("<%s>", field));
				end

				if type(sk) == "string" then
					add(("<%s>%s</%s>"):format(sk, tostring(sv), sk));
				elseif field == "author" then
					local first, last = sv:match("(%S+)%s+(%S+)"); -- Names are hard
					add(("<firstname>%s</firstname>"):format(first));
					add(("<surname>%s</surname>"):format(last));
					-- The values have already be converted to the output format.
					-- This means author entries with e.g. <user@example.com> will already
					-- have been converted into <link url='mailto:user@example.com'> by the
					-- Link() function. Hence this hacky parser to get back the original info.
					for typ, addr in sv:gmatch("%surl='(%a+):([^']+)") do
						if typ == "mailto" then
							add(("<email>%s</email>"):format(addr));
						elseif typ == "xmpp" then
							add(("<jid>%s</jid>"):format(addr));
						end
					end
				elseif field == "dependencies" then
					add(("<spec>%s</spec>"):format(tostring(sv)));
				elseif field == "revision" then
					for rev_field in string.gmatch("( version, date, initials )", "%w+") do
						add(("<%s>%s</%s>"):format(rev_field, tostring(sv[rev_field]), rev_field));
					end
					add("<remark>");
					for _, remark in ipairs(sv.remark) do
						add(("<p>%s</p>"):format(remark));
					end
					add("</remark>");
				else
					add(tostring(sv));
				end
				if repeated then
					add(string.format("</%s>", field));
				end
			end
			if not repeated then
				add(string.format("</%s>", field));
			end
		else
			add(("<%s>%s</%s>"):format(field, tostring(v), field));
		end
		::next::
	end
	add("</header>");
  add(body)
	for i = #sectionstack, 1, -1 do
		add("</section"..sectionstack[i]..">");
	end
	add("</xep>\n");
  return table.concat(buffer,'\n') .. '\n'
end

-- The functions that follow render corresponding pandoc elements.
-- s is always a string, attr is always a table of attributes, and
-- items is always an array of strings (the items in a list).
-- Comments indicate the types of other variables.

function Str(s)
  if string.match(s, "^&[%w%-.]+;$") then return s; end
  return escape(s)
end

function Space()
  return " "
end

function SoftBreak()
  return "\n"
end

function LineBreak()
  return "<br/>"
end

function Emph(s)
  return "<em>" .. s .. "</em>"
end

function Strong(s)
  return "<strong>" .. s .. "</strong>"
end

function Subscript(s)
  return "<sub>" .. s .. "</sub>"
end

function Superscript(s)
  return "<sup>" .. s .. "</sup>"
end

function SmallCaps(s)
  return '<span style="font-variant: small-caps;">' .. s .. '</span>'
end

function Strikeout(s)
  return '<del>' .. s .. '</del>'
end

function Link(s, src, tit, attr)
  return "<link url='" .. escape(src,true) .. "'>" .. s .. "</link>"
end

function Image(s, src, tit, attr)
  return "<img src='" .. escape(src,true) .. "' title='" ..
         escape(tit,true) .. "'/>"
end

function Code(s, attr)
  return "<tt" .. attributes(attr) .. ">" .. escape(s) .. "</tt>"
end

function InlineMath(s)
  return "\\(" .. escape(s) .. "\\)"
end

function DisplayMath(s)
  return "\\[" .. escape(s) .. "\\]"
end

function SingleQuoted(s)
  return "'" .. s .. "'"
end

function DoubleQuoted(str)
	return escape('"' .. str .. '"');
end

function Note(s)
	return "<note>" .. s .. "</note>";
end

function Span(s, attr)
  return "<span" .. attributes(attr) .. ">" .. s .. "</span>"
end

function RawInline(format, str)
  if format == "html" then
    return str
  else
    return ''
  end
end

function Cite(s, cs)
  local ids = {}
  for _,cit in ipairs(cs) do
    table.insert(ids, cit.citationId)
  end
  return "<span class=\"cite\" data-citation-ids=\"" .. table.concat(ids, ",") ..
    "\">" .. s .. "</span>"
end

function Plain(s)
  return s
end

function Para(s)
  return "<p>" .. s .. "</p>"
end

-- lev is an integer, the header level.
function Header(lev, s, attr)
	local ret = ""
	if sectionstack[1] and sectionstack[#sectionstack] >= lev then
		repeat
			ret = ret .. "</section"..table.remove(sectionstack)..">"
		until sectionstack[1] == nil or sectionstack[#sectionstack] == lev -1;
	end
	table.insert(sectionstack, lev);
	attr.topic = s;
	attr.anchor, attr.id = attr.id, nil;
  ret = ret .. "<section" .. lev .. attributes(attr) ..  ">"
	return ret;
end

function BlockQuote(s)
  return "<blockquote>\n" .. s .. "\n</blockquote>"
end

function HorizontalRule()
  return "<hr/>"
end

function LineBlock(ls)
  return '<div style="white-space: pre-line;">' .. table.concat(ls, '\n') ..
         '</div>'
end

local function has(haystack, needle) --> boolean
	if type(haystack) == "table" then
		for _, v in ipairs(haystack) do
			if v == needle then return true; end
		end
	elseif type(haystack) == "string" then
		for v in haystack:gmatch("%S+") do
			if v == needle then return true; end
		end
	else
		error("unhandled haystack type "..type(haystack))
	end
	return false;
end

function CodeBlock(s, attr)
	if attr and attr.class and (has(attr.class, "example") or has(attr.class, "xml")) then
		return "<example><![CDATA[".. s ..  "]]></example>"
	else
		return "<code><![CDATA[".. s ..  "]]></code>"
	end
end

function BulletList(items)
  local buffer = {}
  for _, item in pairs(items) do
    table.insert(buffer, "<li>" .. item .. "</li>")
  end
  return "<ul>\n" .. table.concat(buffer, "\n") .. "\n</ul>"
end

function OrderedList(items)
  local buffer = {}
  for _, item in pairs(items) do
    table.insert(buffer, "<li>" .. item .. "</li>")
  end
  return "<ol>\n" .. table.concat(buffer, "\n") .. "\n</ol>"
end

function DefinitionList(items)
  local buffer = {}
  for _,item in pairs(items) do
    local k, v = next(item)
      table.insert(buffer,"<di><dt>" .. k .. "</dt>\n<dd>" ..
                        table.concat(v,"</dd>\n<dd>") .. "</dd></di>")
  end
  return "<dl>\n" .. table.concat(buffer, "\n") .. "\n</dl>"
end

-- Convert pandoc alignment to something HTML can use.
-- align is AlignLeft, AlignRight, AlignCenter, or AlignDefault.
local function html_align(align)
  if align == 'AlignLeft' then
    return 'left'
  elseif align == 'AlignRight' then
    return 'right'
  elseif align == 'AlignCenter' then
    return 'center'
  else
    return 'left'
  end
end

function CaptionedImage(src, tit, caption, attr)
   return '<div class="figure">\n<img src="' .. escape(src,true) ..
      '" title="' .. escape(tit,true) .. '"/>\n' ..
      '<p class="caption">' .. caption .. '</p>\n</div>'
end

-- Caption is a string, aligns is an array of strings,
-- widths is an array of floats, headers is an array of
-- strings, rows is an array of arrays of strings.
function Table(caption, aligns, widths, headers, rows)
  local buffer = {}
  local function add(s)
    table.insert(buffer, s)
  end
  add("<table>")
  if caption ~= "" then
    add("<caption>" .. caption .. "</caption>")
  end
  if widths and widths[1] ~= 0 then
    for _, w in pairs(widths) do
      add('<col width="' .. string.format("%.0f%%", w * 100) .. '" />')
    end
  end
  local header_row = {}
  local empty_header = true
  for i, h in pairs(headers) do
    local align = html_align(aligns[i])
    table.insert(header_row,'<th align="' .. align .. '">' .. h .. '</th>')
    empty_header = empty_header and h == ""
  end
  if not empty_header then
    add('<tr class="header">')
    for _,h in pairs(header_row) do
      add(h)
    end
    add('</tr>')
  else
    -- head = "" -- XXX What is this?
  end
  local class = "even"
  for _, row in pairs(rows) do
    class = (class == "even" and "odd") or "even"
    add('<tr class="' .. class .. '">')
    for i,c in pairs(row) do
      add('<td align="' .. html_align(aligns[i]) .. '">' .. c .. '</td>')
    end
    add('</tr>')
  end
  add('</table>')
  return table.concat(buffer,'\n')
end

function RawBlock(format, str)
  if format == "html" then
    return str
  else
    return ''
  end
end

function Div(s, attr)
  return "<div" .. attributes(attr) .. ">\n" .. s .. "</div>"
end

-- The following code will produce runtime warnings when you haven't defined
-- all of the functions you need for the custom writer, so it's useful
-- to include when you're working on a writer.
local meta = {}
meta.__index =
  function(_, key)
    io.stderr:write(string.format("WARNING: Undefined function '%s'\n",key))
    return function() return "" end
  end
setmetatable(_G, meta)

