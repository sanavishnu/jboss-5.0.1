/*
 * Embedded Jopr Project
 * Copyright (C) 2006-2009 Red Hat, Inc.
 * All rights reserved.
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as
 * published by the Free Software Foundation; either version 2.1 of
 * the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with this program; if not, write to the Free Software
 * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 */

//**********************************************************************************************************/
// NOTE: This file is a copy of rhq.js, r1832. If that file is updated, this file should be updated as well!
//**********************************************************************************************************/

/**
 * The theme used for all PWC (i.e. window.js) windows.
 *
 * TODO: We should define our own PWC theme that matches the L&F of the rest of the app.
 */
var WINDOW_THEME = 'alphacube';

/**
 * A special value for an input that tells the server-side that the corresponding value should be set to null.
 */
var NULL_INPUT_VALUE = " ";

/**
 * Set the unset status of the specified input.
 *
 * @param input an input element
 * @param unset whether or not the input should be unset
 */
function setInputUnset(input, unset)
{
    clearInputValue(input);
    setInputDisabled(input, unset, true);
    input.unset = unset; // our own special property that tells us whether an input is unset
    if (!unset)
    {
        // Set focus on the input, but only if it is a text-entry field - it doesn't make sense for radios, checkboxes,
        // etc.
        if (input.type == 'text' || input.type == 'password' || input.type == 'textarea' || input.type == 'file')
        {
            input.focus();
        }
    }
}

/**
 * Write-protect the specified input element.
 *
 * @param input an input element
 */
function writeProtectInput(input)
{
    if (input.length != null && (input[0].type == 'radio' || input[0].type == 'select-multiple'))
    {
        // Recursively call ourself for each of the array items, which are the actual radio buttons or menu items.
        for (var i = 0; i < input.length; i++)
        {
            writeProtectInput(input[i]);
        }
    }
    else
    {
        input.readonly = true;
        // NOTE: For non-text inputs (radios, checkboxes, etc), the "readonly" attribute is ignored by browsers, so we
        //       resort to the "disabled" attribute for these types of inputs. For the text inputs, it is important to
        //       *not* set the "disabled" attribute, because then the browser does not allow them to receive focus, which
        //       prevents tooltips from working (see http://jira.jboss.com/jira/browse/JBNADM-1608).
        if (input.type != 'text' && input.type != 'password' && input.type != 'textarea' && input.type != 'file')
        {
            setInputDisabled(input, true, true);
        }
    }
}

/**
 * Set the "title" attribute on the specified text input. If the input's value is longer than the size of the input,
 * set the title to the value. Otherwise, set the title to null.
 *
 * @param input an input element
 */
function setInputTitle(input)
{
    if (input != null && input.type == 'text')
    {
        if (input.value != null && input.value.length > input.size)
        {
            input.title = input.value;
        }
        else
        {
            input.title = null;
        }
    }
}

/**
 * Clear the value of the specified input.
 *
 * @param input an input element
 */
function clearInputValue(input)
{
    if (input.length != null)
    {
        if (input[0].type == 'radio')
        {
            // Recursively call ourself for each of the array items, which are the actual radio buttons.
            for (var i = 0; i < input.length; i++)
            {
                clearInputValue(input[i]);
            }
        }
        else if (input[0].type == 'select-one' || input[0].type == 'select-multiple')
        {
            // Recursively call ourself on the selected item.
            clearInputValue(input[input.selectedIndex]);
        }
    }
    else
    {
        switch (input.type)
                {
            case 'checkbox':
            case 'radio':
                input.checked = false; break;
            case 'select-one':
            case 'select-multiple':
                input.selected = false; break;
            default:
                // NOTE: We set the value to an empty string rather than null, because IE converts null to the string 'null'.
                input.value = '';
        }
    }
}

/**
 * Disable or enable the specified input element.
 *
 * @param input an input element
 * @param disabled if true, disable the input; otherwise, enable it
 * @param updateStyle whether or not the input's CSS style should be updated (i.e. grayed out if being disabled or
 *                    un-grayed-out if being enabled)
 */
function setInputDisabled(input, disabled, updateStyle)
{
    if (input.length != null && (input[0].type == 'radio' || input[0].type == 'select-multiple'))
    {
        // Recursively call ourself for each of the array items, which are the actual radio buttons or menu items.
        for (var i = 0; i < input.length; i++)
        {
            setInputDisabled(input[i], disabled, updateStyle);
        }
    }
    else
    {
        input.disabled = disabled;
        if (updateStyle)
        {
            updateInputStyle(input);
        }
    }
}

/**
 * "Unsets" an array of input elements.
 *
 * @param inputs an array of input elements
 */
function unsetInputs(inputs)
{
    for (var i = 0; i < inputs.length; i++)
    {
        setInputUnset(inputs[i], true);
    }
}

function setInputsOverride(inputs, shouldOverride)
{
    for (var i = 0; i < inputs.length; i++)
    {
        setInputOverride(inputs[i], shouldOverride);
    }
}

function setInputOverride(input, shouldOverride)
{
    input.override = shouldOverride;
    if (shouldOverride)
    {
        input.check();
    }
}

/**
 * Write-protects an array of input elements.
 *
 * @param inputs an array of input elements
 */
function writeProtectInputs(inputs)
{
    for (var i = 0; i < inputs.length; i++)
    {
        writeProtectInput(inputs[i]);
    }
}

/**
 * @param form a form element
 */
function prepareInputsForSubmission(form)
{
    var inputs = Form.getInputs(form);
    for (var i = 0; i < inputs.length; i++)
    {
        var input = inputs[i];
        if (input.disabled)
        {
            // NOTE: It is vital to enable any disabled inputs, since the browser will exclude disabled inputs from the
            //       POST request.
            setInputDisabled(input, false, false);
            // Some browsers (e.g. Firefox) will automatically un-gray-out the input, when the disabled property is
            // set to false, so we need to gray it out again, so it still appears to be disabled.
            grayOutInput(input);
            if (input.unset)
            {
                // NOTE: Set the input's value to a special string that will allow the server-side to distinguish between a
                //       null (i.e. unset) value and an empty string value.
                input.value = NULL_INPUT_VALUE;
            }
        }
    }
}

/**
 * @param input an input element
 */
function updateInputStyle(input)
{
    if (input.disabled)
    {
        grayOutInput(input);
    }
    else
    {
        input.style.background = '#FFFFFF';
        input.style.color = '#000000';
        input.style.border = '1px solid #A7A6AA';
    }
}

/**
 * @param input an input element
 */
function grayOutInput(input)
{
    // Use the default Firefox colors, which are much more intuitive than the default IE colors.
    input.style.background = '#D6D5D9';
    input.style.color = '#000000';
    input.style.border = '1px solid #A7A6AA';
}

/**
 * @param title the title to be displayed at the top of the modal
 * @param message the message to be displayed in the body the modal
 */
function displayMessageModal(title, message)
{
    var win = new Window({className:WINDOW_THEME, width:350, height:400, zIndex: 100, resizable:true, showEffect:Effect.BlindDown, hideEffect:Effect.SwitchOff, draggable:true, wiredDrag:true});
    win.getContent().innerHTML = "<div style='padding:10px'>" + message + "</div>";
    win.setTitle(title);
    win.showCenter(true); // true == modal
}

/**
 * This method is called in the onload of the body of
 * the main template to disable all conditional buttons
 */
function disableConditionalButtons()
{
    var buttons = document.getElementsByTagName("input");
    var i;
    var button;
    for (i = 0; i < buttons.length; i++)
    {
        button = buttons.item(i);
        if (button.getAttribute("target") != null)
        {
            button.disabled = true;
        }
    }
}

/**
 * @param thisObj    the calling AllSelect object instance use to determine whether
 *                   or select or deselect all of the objects with the name selectName
 * @param selectName name of the dom instances that should be checked / unchecked
 */
function selectAll(thisObj, selectName)
{
    var selects = document.getElementsByName(selectName);
    var i;
    var select;
    for (i = 0; i < selects.length; i++)
    {
        select = selects.item(i);
        if (select.disabled)
        {
            continue;
        }
        if (thisObj.checked)
        {
            select.checked = true;
        }
        else
        {
            select.checked = false;
        }
    }
    updateButtons(selectName);
}

/**
 * This method will be called either:
 *   1) directly as a result of checking or unchecking a single Select component, or
 *   2) as the final task of the selectAll method
 *
 * @param selectName name of the dom instances that are checked or unchecked which will determine
 *                   whether or not the conditional buttons on the page should be enabled / disabled
 */
// TODO: Make this robust enough to properly maintain CSS style when the button is disabled (ips, 08/31/07).
function updateButtons(targetName)
{
    var count = countSelected(targetName);
    var buttons = document.getElementsByTagName("input");
    var i;
    var button;
    for (i = 0; i < buttons.length; i++)
    {
        button = buttons.item(i);
        if (button.getAttribute("target") != null && button.getAttribute("target") == targetName)
        {
            var low = button.getAttribute("low");
            var high = button.getAttribute("high");
            if (high != null)
            {
                if (low <= count && count <= high)
                {
                    button.disabled = false;
                }
                else
                {
                    button.disabled = true;
                }
            }
            else
            {
                if (low <= count)
                {
                    button.disabled = false;
                }
                else
                {
                    button.disabled = true;
                }
            }
        }
    }
}

/**
 * Returns the number of checkboxes with the given name that are currently selected
 *
 * @param selectName name of the dom instances that should be counted for selections
 */
function countSelected(selectName)
{
    var total = 0;
    var selectElts = document.getElementsByName(selectName);
    var i;
    for (i = 0; i < selectElts.length; i++)
    {
        if (selectElts.item(i).checked)
        {
            total = total + 1;
        }
    }
    return (total);
}

function setFoot()
{
    var conH;
    var winH;
    var footerH = 28;
    var browserH = 88;
    if (isIE)
    {
        conH = document.body.scrollHeight;
        winH = document.body.clientHeight;
    }
    else
    {
        conH = document.height;
        winH = window.innerHeight;
    }
    var myHeight = winH - conH - footerH + browserH;
    if (myHeight > 60)
    {
        var footerSpacer = document.getElementById("footerSpacer");
        footerSpacer.setAttribute('height', myHeight);
    }
}

function openAbout(windowTitle)
{
    var content = $('about').innerHTML;
    // NOTE: The PWC docs say the 'closable' option defaults to true, but this does not appear to be the case.
    var windowOptions = {className:WINDOW_THEME, title:windowTitle, width:296, height:164, closable:true, minimizable:false, maximizable:false, resize:false, draggable:false, effectOptions:{duration: 0.25}};
    Dialog.alert(content, windowOptions);
}

/**
 * Sends a click event to the anchor element with the specified id.
 * See http://wiki.apache.org/myfaces/JavascriptWithJavaServerFaces.
 *
 * @param anchorId the id of an anchor element
 */
function clickAnchor(anchorId)
{
    var anchor = document.getElementById(anchorId);
    if (document.createEvent)
    {
        var event = document.createEvent('MouseEvents');
        event.initEvent('click', true, false);
        anchor.dispatchEvent(event);
    }
    else if (document.createEventObject)
    {
        anchor.fireEvent('onclick');
    }
}

function hidediv(elementId)
{
    document.getElementById(elementId).style.visibility = 'hidden';
    document.getElementById(elementId).style.display = 'none';
}

function showdiv(elementId)
{
    document.getElementById(elementId).style.visibility = 'visible';
    document.getElementById(elementId).style.display = 'block';
}

function clickRadio(radioName, valueToClick)
{
    var radioSet = document.getElementsByName(radioName);
    var i;
    for (i = 0; i < radioSet.length; i++)
    {
        if (radioSet.item(i).value == valueToClick)
        {
            radioSet.item(i).click();
        }
    }
}
