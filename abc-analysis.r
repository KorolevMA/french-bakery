{
 "cells": [
  {
   "cell_type": "markdown",
   "id": "4e8715d1",
   "metadata": {
    "papermill": {
     "duration": 0.010119,
     "end_time": "2024-06-02T22:23:16.865829",
     "exception": false,
     "start_time": "2024-06-02T22:23:16.855710",
     "status": "completed"
    },
    "tags": []
   },
   "source": [
    "DataSet orders of french bakery.\n",
    "\n",
    "## Goals of analysis\n",
    "\n",
    "1.  Find most profitable products\n",
    "2.  Suggest a strategy for this company\n",
    "\n",
    "We will use ABC analysis\n",
    "\n",
    "Lets go!\n",
    "\n",
    "### Import and first look"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 1,
   "id": "84e924c3",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2024-06-02T22:23:16.890774Z",
     "iopub.status.busy": "2024-06-02T22:23:16.887268Z",
     "iopub.status.idle": "2024-06-02T22:23:18.185129Z",
     "shell.execute_reply": "2024-06-02T22:23:18.182658Z"
    },
    "papermill": {
     "duration": 1.312909,
     "end_time": "2024-06-02T22:23:18.188059",
     "exception": false,
     "start_time": "2024-06-02T22:23:16.875150",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [
    {
     "name": "stderr",
     "output_type": "stream",
     "text": [
      "── \u001b[1mAttaching core tidyverse packages\u001b[22m ──────────────────────── tidyverse 2.0.0 ──\n",
      "\u001b[32m✔\u001b[39m \u001b[34mdplyr    \u001b[39m 1.1.4     \u001b[32m✔\u001b[39m \u001b[34mreadr    \u001b[39m 2.1.4\n",
      "\u001b[32m✔\u001b[39m \u001b[34mforcats  \u001b[39m 1.0.0     \u001b[32m✔\u001b[39m \u001b[34mstringr  \u001b[39m 1.5.1\n",
      "\u001b[32m✔\u001b[39m \u001b[34mggplot2  \u001b[39m 3.4.4     \u001b[32m✔\u001b[39m \u001b[34mtibble   \u001b[39m 3.2.1\n",
      "\u001b[32m✔\u001b[39m \u001b[34mlubridate\u001b[39m 1.9.3     \u001b[32m✔\u001b[39m \u001b[34mtidyr    \u001b[39m 1.3.0\n",
      "\u001b[32m✔\u001b[39m \u001b[34mpurrr    \u001b[39m 1.0.2     \n",
      "── \u001b[1mConflicts\u001b[22m ────────────────────────────────────────── tidyverse_conflicts() ──\n",
      "\u001b[31m✖\u001b[39m \u001b[34mdplyr\u001b[39m::\u001b[32mfilter()\u001b[39m masks \u001b[34mstats\u001b[39m::filter()\n",
      "\u001b[31m✖\u001b[39m \u001b[34mdplyr\u001b[39m::\u001b[32mlag()\u001b[39m    masks \u001b[34mstats\u001b[39m::lag()\n",
      "\u001b[36mℹ\u001b[39m Use the conflicted package (\u001b[3m\u001b[34m<http://conflicted.r-lib.org/>\u001b[39m\u001b[23m) to force all conflicts to become errors\n",
      "\n",
      "Attaching package: ‘scales’\n",
      "\n",
      "\n",
      "The following object is masked from ‘package:purrr’:\n",
      "\n",
      "    discard\n",
      "\n",
      "\n",
      "The following object is masked from ‘package:readr’:\n",
      "\n",
      "    col_factor\n",
      "\n",
      "\n"
     ]
    }
   ],
   "source": [
    "library(tidyverse)\n",
    "library(stringr)\n",
    "library(ggplot2)\n",
    "library(lubridate)\n",
    "library(scales)"
   ]
  },
  {
   "cell_type": "markdown",
   "id": "e315fe12",
   "metadata": {
    "papermill": {
     "duration": 0.010111,
     "end_time": "2024-06-02T22:23:18.208811",
     "exception": false,
     "start_time": "2024-06-02T22:23:18.198700",
     "status": "completed"
    },
    "tags": []
   },
   "source": [
    "Load data"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 2,
   "id": "4133ca19",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2024-06-02T22:23:18.267146Z",
     "iopub.status.busy": "2024-06-02T22:23:18.231970Z",
     "iopub.status.idle": "2024-06-02T22:23:19.072874Z",
     "shell.execute_reply": "2024-06-02T22:23:19.070852Z"
    },
    "papermill": {
     "duration": 0.856404,
     "end_time": "2024-06-02T22:23:19.075626",
     "exception": false,
     "start_time": "2024-06-02T22:23:18.219222",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [
    {
     "name": "stderr",
     "output_type": "stream",
     "text": [
      "\u001b[1m\u001b[22mNew names:\n",
      "\u001b[36m•\u001b[39m `` -> `...1`\n",
      "\u001b[1mRows: \u001b[22m\u001b[34m234005\u001b[39m \u001b[1mColumns: \u001b[22m\u001b[34m7\u001b[39m\n",
      "\u001b[36m──\u001b[39m \u001b[1mColumn specification\u001b[22m \u001b[36m────────────────────────────────────────────────────────\u001b[39m\n",
      "\u001b[1mDelimiter:\u001b[22m \",\"\n",
      "\u001b[31mchr\u001b[39m  (2): article, unit_price\n",
      "\u001b[32mdbl\u001b[39m  (3): ...1, ticket_number, Quantity\n",
      "\u001b[34mdate\u001b[39m (1): date\n",
      "\u001b[34mtime\u001b[39m (1): time\n",
      "\n",
      "\u001b[36mℹ\u001b[39m Use `spec()` to retrieve the full column specification for this data.\n",
      "\u001b[36mℹ\u001b[39m Specify the column types or set `show_col_types = FALSE` to quiet this message.\n"
     ]
    },
    {
     "data": {
      "text/html": [
       "<table class=\"dataframe\">\n",
       "<caption>A spec_tbl_df: 234005 × 7</caption>\n",
       "<thead>\n",
       "\t<tr><th scope=col>...1</th><th scope=col>date</th><th scope=col>time</th><th scope=col>ticket_number</th><th scope=col>article</th><th scope=col>Quantity</th><th scope=col>unit_price</th></tr>\n",
       "\t<tr><th scope=col>&lt;dbl&gt;</th><th scope=col>&lt;date&gt;</th><th scope=col>&lt;time&gt;</th><th scope=col>&lt;dbl&gt;</th><th scope=col>&lt;chr&gt;</th><th scope=col>&lt;dbl&gt;</th><th scope=col>&lt;chr&gt;</th></tr>\n",
       "</thead>\n",
       "<tbody>\n",
       "\t<tr><td> 0</td><td>2021-01-02</td><td>08:38:00</td><td>150040</td><td>BAGUETTE            </td><td>1</td><td>0,90 €</td></tr>\n",
       "\t<tr><td> 1</td><td>2021-01-02</td><td>08:38:00</td><td>150040</td><td>PAIN AU CHOCOLAT    </td><td>3</td><td>1,20 €</td></tr>\n",
       "\t<tr><td> 4</td><td>2021-01-02</td><td>09:14:00</td><td>150041</td><td>PAIN AU CHOCOLAT    </td><td>2</td><td>1,20 €</td></tr>\n",
       "\t<tr><td> 5</td><td>2021-01-02</td><td>09:14:00</td><td>150041</td><td>PAIN                </td><td>1</td><td>1,15 €</td></tr>\n",
       "\t<tr><td> 8</td><td>2021-01-02</td><td>09:25:00</td><td>150042</td><td>TRADITIONAL BAGUETTE</td><td>5</td><td>1,20 €</td></tr>\n",
       "\t<tr><td>11</td><td>2021-01-02</td><td>09:25:00</td><td>150043</td><td>BAGUETTE            </td><td>2</td><td>0,90 €</td></tr>\n",
       "\t<tr><td>12</td><td>2021-01-02</td><td>09:25:00</td><td>150043</td><td>CROISSANT           </td><td>3</td><td>1,10 €</td></tr>\n",
       "\t<tr><td>15</td><td>2021-01-02</td><td>09:27:00</td><td>150044</td><td>BANETTE             </td><td>1</td><td>1,05 €</td></tr>\n",
       "\t<tr><td>18</td><td>2021-01-02</td><td>09:32:00</td><td>150045</td><td>TRADITIONAL BAGUETTE</td><td>3</td><td>1,20 €</td></tr>\n",
       "\t<tr><td>19</td><td>2021-01-02</td><td>09:32:00</td><td>150045</td><td>CROISSANT           </td><td>6</td><td>1,10 €</td></tr>\n",
       "\t<tr><td>22</td><td>2021-01-02</td><td>09:37:00</td><td>150046</td><td>PAIN AU CHOCOLAT    </td><td>6</td><td>1,20 €</td></tr>\n",
       "\t<tr><td>23</td><td>2021-01-02</td><td>09:37:00</td><td>150046</td><td>CROISSANT           </td><td>6</td><td>1,10 €</td></tr>\n",
       "\t<tr><td>24</td><td>2021-01-02</td><td>09:37:00</td><td>150046</td><td>TRADITIONAL BAGUETTE</td><td>6</td><td>1,20 €</td></tr>\n",
       "\t<tr><td>29</td><td>2021-01-02</td><td>09:39:00</td><td>150048</td><td>CROISSANT           </td><td>3</td><td>1,10 €</td></tr>\n",
       "\t<tr><td>32</td><td>2021-01-02</td><td>09:40:00</td><td>150049</td><td>CROISSANT           </td><td>2</td><td>1,10 €</td></tr>\n",
       "\t<tr><td>33</td><td>2021-01-02</td><td>09:40:00</td><td>150049</td><td>TRADITIONAL BAGUETTE</td><td>1</td><td>1,20 €</td></tr>\n",
       "\t<tr><td>36</td><td>2021-01-02</td><td>09:41:00</td><td>150050</td><td>TRADITIONAL BAGUETTE</td><td>2</td><td>1,20 €</td></tr>\n",
       "\t<tr><td>39</td><td>2021-01-02</td><td>09:46:00</td><td>150051</td><td>PAIN                </td><td>1</td><td>1,15 €</td></tr>\n",
       "\t<tr><td>42</td><td>2021-01-02</td><td>09:48:00</td><td>150052</td><td>BANETTINE           </td><td>1</td><td>0,60 €</td></tr>\n",
       "\t<tr><td>43</td><td>2021-01-02</td><td>09:48:00</td><td>150052</td><td>SPECIAL BREAD       </td><td>1</td><td>2,40 €</td></tr>\n",
       "\t<tr><td>44</td><td>2021-01-02</td><td>09:48:00</td><td>150052</td><td>COUPE               </td><td>1</td><td>0,15 €</td></tr>\n",
       "\t<tr><td>47</td><td>2021-01-02</td><td>09:48:00</td><td>150053</td><td>TRADITIONAL BAGUETTE</td><td>1</td><td>1,20 €</td></tr>\n",
       "\t<tr><td>48</td><td>2021-01-02</td><td>09:48:00</td><td>150053</td><td>SAND JB EMMENTAL    </td><td>2</td><td>3,50 €</td></tr>\n",
       "\t<tr><td>51</td><td>2021-01-02</td><td>09:49:00</td><td>150054</td><td>KOUIGN AMANN        </td><td>1</td><td>2,10 €</td></tr>\n",
       "\t<tr><td>52</td><td>2021-01-02</td><td>09:49:00</td><td>150054</td><td>PAIN                </td><td>2</td><td>1,15 €</td></tr>\n",
       "\t<tr><td>55</td><td>2021-01-02</td><td>09:57:00</td><td>150055</td><td>TRADITIONAL BAGUETTE</td><td>4</td><td>1,20 €</td></tr>\n",
       "\t<tr><td>58</td><td>2021-01-02</td><td>09:58:00</td><td>150056</td><td>BANETTE             </td><td>3</td><td>1,05 €</td></tr>\n",
       "\t<tr><td>59</td><td>2021-01-02</td><td>09:58:00</td><td>150056</td><td>CROISSANT           </td><td>5</td><td>1,10 €</td></tr>\n",
       "\t<tr><td>64</td><td>2021-01-02</td><td>10:03:00</td><td>150058</td><td>TRADITIONAL BAGUETTE</td><td>2</td><td>1,20 €</td></tr>\n",
       "\t<tr><td>65</td><td>2021-01-02</td><td>10:03:00</td><td>150058</td><td>CROISSANT           </td><td>2</td><td>1,10 €</td></tr>\n",
       "\t<tr><td>⋮</td><td>⋮</td><td>⋮</td><td>⋮</td><td>⋮</td><td>⋮</td><td>⋮</td></tr>\n",
       "\t<tr><td>511324</td><td>2022-09-30</td><td>17:19:00</td><td>288892</td><td>CEREAL BAGUETTE     </td><td>1</td><td>1,35 €</td></tr>\n",
       "\t<tr><td>511327</td><td>2022-09-30</td><td>17:25:00</td><td>288893</td><td>CEREAL BAGUETTE     </td><td>1</td><td>1,35 €</td></tr>\n",
       "\t<tr><td>511330</td><td>2022-09-30</td><td>17:31:00</td><td>288894</td><td>TRADITIONAL BAGUETTE</td><td>1</td><td>1,30 €</td></tr>\n",
       "\t<tr><td>511333</td><td>2022-09-30</td><td>17:37:00</td><td>288895</td><td>TRADITIONAL BAGUETTE</td><td>1</td><td>1,30 €</td></tr>\n",
       "\t<tr><td>511336</td><td>2022-09-30</td><td>17:41:00</td><td>288896</td><td>TRADITIONAL BAGUETTE</td><td>1</td><td>1,30 €</td></tr>\n",
       "\t<tr><td>511339</td><td>2022-09-30</td><td>17:58:00</td><td>288897</td><td>CAMPAGNE            </td><td>1</td><td>2,00 €</td></tr>\n",
       "\t<tr><td>511340</td><td>2022-09-30</td><td>17:58:00</td><td>288897</td><td>COUPE               </td><td>1</td><td>0,15 €</td></tr>\n",
       "\t<tr><td>511341</td><td>2022-09-30</td><td>17:58:00</td><td>288897</td><td>ECLAIR              </td><td>1</td><td>2,20 €</td></tr>\n",
       "\t<tr><td>511344</td><td>2022-09-30</td><td>18:02:00</td><td>288898</td><td>TRADITIONAL BAGUETTE</td><td>1</td><td>1,30 €</td></tr>\n",
       "\t<tr><td>511347</td><td>2022-09-30</td><td>18:08:00</td><td>288899</td><td>TRADITIONAL BAGUETTE</td><td>1</td><td>1,30 €</td></tr>\n",
       "\t<tr><td>511350</td><td>2022-09-30</td><td>18:17:00</td><td>288900</td><td>TRADITIONAL BAGUETTE</td><td>4</td><td>1,30 €</td></tr>\n",
       "\t<tr><td>511353</td><td>2022-09-30</td><td>18:19:00</td><td>288901</td><td>CARAMEL NOIX        </td><td>1</td><td>2,40 €</td></tr>\n",
       "\t<tr><td>511354</td><td>2022-09-30</td><td>18:19:00</td><td>288901</td><td>FLAN                </td><td>1</td><td>2,20 €</td></tr>\n",
       "\t<tr><td>511355</td><td>2022-09-30</td><td>18:19:00</td><td>288901</td><td>TRADITIONAL BAGUETTE</td><td>1</td><td>1,30 €</td></tr>\n",
       "\t<tr><td>511358</td><td>2022-09-30</td><td>18:22:00</td><td>288902</td><td>BANETTE             </td><td>1</td><td>1,15 €</td></tr>\n",
       "\t<tr><td>511361</td><td>2022-09-30</td><td>18:24:00</td><td>288903</td><td>CEREAL BAGUETTE     </td><td>3</td><td>1,35 €</td></tr>\n",
       "\t<tr><td>511362</td><td>2022-09-30</td><td>18:24:00</td><td>288903</td><td>DIVERS CONFISERIE   </td><td>1</td><td>6,00 €</td></tr>\n",
       "\t<tr><td>511363</td><td>2022-09-30</td><td>18:24:00</td><td>288903</td><td>TRADITIONAL BAGUETTE</td><td>4</td><td>1,30 €</td></tr>\n",
       "\t<tr><td>511368</td><td>2022-09-30</td><td>18:26:00</td><td>288905</td><td>TRADITIONAL BAGUETTE</td><td>1</td><td>1,30 €</td></tr>\n",
       "\t<tr><td>511373</td><td>2022-09-30</td><td>18:30:00</td><td>288907</td><td>COUPE               </td><td>1</td><td>0,15 €</td></tr>\n",
       "\t<tr><td>511374</td><td>2022-09-30</td><td>18:30:00</td><td>288907</td><td>CAMPAGNE            </td><td>1</td><td>2,00 €</td></tr>\n",
       "\t<tr><td>511377</td><td>2022-09-30</td><td>18:34:00</td><td>288908</td><td>CEREAL BAGUETTE     </td><td>2</td><td>1,35 €</td></tr>\n",
       "\t<tr><td>511382</td><td>2022-09-30</td><td>18:39:00</td><td>288910</td><td>TRADITIONAL BAGUETTE</td><td>1</td><td>1,30 €</td></tr>\n",
       "\t<tr><td>511385</td><td>2022-09-30</td><td>18:52:00</td><td>288911</td><td>CAMPAGNE            </td><td>2</td><td>2,00 €</td></tr>\n",
       "\t<tr><td>511386</td><td>2022-09-30</td><td>18:52:00</td><td>288911</td><td>TRADITIONAL BAGUETTE</td><td>5</td><td>1,30 €</td></tr>\n",
       "\t<tr><td>511387</td><td>2022-09-30</td><td>18:52:00</td><td>288911</td><td>COUPE               </td><td>1</td><td>0,15 €</td></tr>\n",
       "\t<tr><td>511388</td><td>2022-09-30</td><td>18:52:00</td><td>288911</td><td>BOULE 200G          </td><td>1</td><td>1,20 €</td></tr>\n",
       "\t<tr><td>511389</td><td>2022-09-30</td><td>18:52:00</td><td>288911</td><td>COUPE               </td><td>2</td><td>0,15 €</td></tr>\n",
       "\t<tr><td>511392</td><td>2022-09-30</td><td>18:55:00</td><td>288912</td><td>TRADITIONAL BAGUETTE</td><td>1</td><td>1,30 €</td></tr>\n",
       "\t<tr><td>511395</td><td>2022-09-30</td><td>18:56:00</td><td>288913</td><td>TRADITIONAL BAGUETTE</td><td>1</td><td>1,30 €</td></tr>\n",
       "</tbody>\n",
       "</table>\n"
      ],
      "text/latex": [
       "A spec\\_tbl\\_df: 234005 × 7\n",
       "\\begin{tabular}{lllllll}\n",
       " ...1 & date & time & ticket\\_number & article & Quantity & unit\\_price\\\\\n",
       " <dbl> & <date> & <time> & <dbl> & <chr> & <dbl> & <chr>\\\\\n",
       "\\hline\n",
       "\t  0 & 2021-01-02 & 08:38:00 & 150040 & BAGUETTE             & 1 & 0,90 €\\\\\n",
       "\t  1 & 2021-01-02 & 08:38:00 & 150040 & PAIN AU CHOCOLAT     & 3 & 1,20 €\\\\\n",
       "\t  4 & 2021-01-02 & 09:14:00 & 150041 & PAIN AU CHOCOLAT     & 2 & 1,20 €\\\\\n",
       "\t  5 & 2021-01-02 & 09:14:00 & 150041 & PAIN                 & 1 & 1,15 €\\\\\n",
       "\t  8 & 2021-01-02 & 09:25:00 & 150042 & TRADITIONAL BAGUETTE & 5 & 1,20 €\\\\\n",
       "\t 11 & 2021-01-02 & 09:25:00 & 150043 & BAGUETTE             & 2 & 0,90 €\\\\\n",
       "\t 12 & 2021-01-02 & 09:25:00 & 150043 & CROISSANT            & 3 & 1,10 €\\\\\n",
       "\t 15 & 2021-01-02 & 09:27:00 & 150044 & BANETTE              & 1 & 1,05 €\\\\\n",
       "\t 18 & 2021-01-02 & 09:32:00 & 150045 & TRADITIONAL BAGUETTE & 3 & 1,20 €\\\\\n",
       "\t 19 & 2021-01-02 & 09:32:00 & 150045 & CROISSANT            & 6 & 1,10 €\\\\\n",
       "\t 22 & 2021-01-02 & 09:37:00 & 150046 & PAIN AU CHOCOLAT     & 6 & 1,20 €\\\\\n",
       "\t 23 & 2021-01-02 & 09:37:00 & 150046 & CROISSANT            & 6 & 1,10 €\\\\\n",
       "\t 24 & 2021-01-02 & 09:37:00 & 150046 & TRADITIONAL BAGUETTE & 6 & 1,20 €\\\\\n",
       "\t 29 & 2021-01-02 & 09:39:00 & 150048 & CROISSANT            & 3 & 1,10 €\\\\\n",
       "\t 32 & 2021-01-02 & 09:40:00 & 150049 & CROISSANT            & 2 & 1,10 €\\\\\n",
       "\t 33 & 2021-01-02 & 09:40:00 & 150049 & TRADITIONAL BAGUETTE & 1 & 1,20 €\\\\\n",
       "\t 36 & 2021-01-02 & 09:41:00 & 150050 & TRADITIONAL BAGUETTE & 2 & 1,20 €\\\\\n",
       "\t 39 & 2021-01-02 & 09:46:00 & 150051 & PAIN                 & 1 & 1,15 €\\\\\n",
       "\t 42 & 2021-01-02 & 09:48:00 & 150052 & BANETTINE            & 1 & 0,60 €\\\\\n",
       "\t 43 & 2021-01-02 & 09:48:00 & 150052 & SPECIAL BREAD        & 1 & 2,40 €\\\\\n",
       "\t 44 & 2021-01-02 & 09:48:00 & 150052 & COUPE                & 1 & 0,15 €\\\\\n",
       "\t 47 & 2021-01-02 & 09:48:00 & 150053 & TRADITIONAL BAGUETTE & 1 & 1,20 €\\\\\n",
       "\t 48 & 2021-01-02 & 09:48:00 & 150053 & SAND JB EMMENTAL     & 2 & 3,50 €\\\\\n",
       "\t 51 & 2021-01-02 & 09:49:00 & 150054 & KOUIGN AMANN         & 1 & 2,10 €\\\\\n",
       "\t 52 & 2021-01-02 & 09:49:00 & 150054 & PAIN                 & 2 & 1,15 €\\\\\n",
       "\t 55 & 2021-01-02 & 09:57:00 & 150055 & TRADITIONAL BAGUETTE & 4 & 1,20 €\\\\\n",
       "\t 58 & 2021-01-02 & 09:58:00 & 150056 & BANETTE              & 3 & 1,05 €\\\\\n",
       "\t 59 & 2021-01-02 & 09:58:00 & 150056 & CROISSANT            & 5 & 1,10 €\\\\\n",
       "\t 64 & 2021-01-02 & 10:03:00 & 150058 & TRADITIONAL BAGUETTE & 2 & 1,20 €\\\\\n",
       "\t 65 & 2021-01-02 & 10:03:00 & 150058 & CROISSANT            & 2 & 1,10 €\\\\\n",
       "\t ⋮ & ⋮ & ⋮ & ⋮ & ⋮ & ⋮ & ⋮\\\\\n",
       "\t 511324 & 2022-09-30 & 17:19:00 & 288892 & CEREAL BAGUETTE      & 1 & 1,35 €\\\\\n",
       "\t 511327 & 2022-09-30 & 17:25:00 & 288893 & CEREAL BAGUETTE      & 1 & 1,35 €\\\\\n",
       "\t 511330 & 2022-09-30 & 17:31:00 & 288894 & TRADITIONAL BAGUETTE & 1 & 1,30 €\\\\\n",
       "\t 511333 & 2022-09-30 & 17:37:00 & 288895 & TRADITIONAL BAGUETTE & 1 & 1,30 €\\\\\n",
       "\t 511336 & 2022-09-30 & 17:41:00 & 288896 & TRADITIONAL BAGUETTE & 1 & 1,30 €\\\\\n",
       "\t 511339 & 2022-09-30 & 17:58:00 & 288897 & CAMPAGNE             & 1 & 2,00 €\\\\\n",
       "\t 511340 & 2022-09-30 & 17:58:00 & 288897 & COUPE                & 1 & 0,15 €\\\\\n",
       "\t 511341 & 2022-09-30 & 17:58:00 & 288897 & ECLAIR               & 1 & 2,20 €\\\\\n",
       "\t 511344 & 2022-09-30 & 18:02:00 & 288898 & TRADITIONAL BAGUETTE & 1 & 1,30 €\\\\\n",
       "\t 511347 & 2022-09-30 & 18:08:00 & 288899 & TRADITIONAL BAGUETTE & 1 & 1,30 €\\\\\n",
       "\t 511350 & 2022-09-30 & 18:17:00 & 288900 & TRADITIONAL BAGUETTE & 4 & 1,30 €\\\\\n",
       "\t 511353 & 2022-09-30 & 18:19:00 & 288901 & CARAMEL NOIX         & 1 & 2,40 €\\\\\n",
       "\t 511354 & 2022-09-30 & 18:19:00 & 288901 & FLAN                 & 1 & 2,20 €\\\\\n",
       "\t 511355 & 2022-09-30 & 18:19:00 & 288901 & TRADITIONAL BAGUETTE & 1 & 1,30 €\\\\\n",
       "\t 511358 & 2022-09-30 & 18:22:00 & 288902 & BANETTE              & 1 & 1,15 €\\\\\n",
       "\t 511361 & 2022-09-30 & 18:24:00 & 288903 & CEREAL BAGUETTE      & 3 & 1,35 €\\\\\n",
       "\t 511362 & 2022-09-30 & 18:24:00 & 288903 & DIVERS CONFISERIE    & 1 & 6,00 €\\\\\n",
       "\t 511363 & 2022-09-30 & 18:24:00 & 288903 & TRADITIONAL BAGUETTE & 4 & 1,30 €\\\\\n",
       "\t 511368 & 2022-09-30 & 18:26:00 & 288905 & TRADITIONAL BAGUETTE & 1 & 1,30 €\\\\\n",
       "\t 511373 & 2022-09-30 & 18:30:00 & 288907 & COUPE                & 1 & 0,15 €\\\\\n",
       "\t 511374 & 2022-09-30 & 18:30:00 & 288907 & CAMPAGNE             & 1 & 2,00 €\\\\\n",
       "\t 511377 & 2022-09-30 & 18:34:00 & 288908 & CEREAL BAGUETTE      & 2 & 1,35 €\\\\\n",
       "\t 511382 & 2022-09-30 & 18:39:00 & 288910 & TRADITIONAL BAGUETTE & 1 & 1,30 €\\\\\n",
       "\t 511385 & 2022-09-30 & 18:52:00 & 288911 & CAMPAGNE             & 2 & 2,00 €\\\\\n",
       "\t 511386 & 2022-09-30 & 18:52:00 & 288911 & TRADITIONAL BAGUETTE & 5 & 1,30 €\\\\\n",
       "\t 511387 & 2022-09-30 & 18:52:00 & 288911 & COUPE                & 1 & 0,15 €\\\\\n",
       "\t 511388 & 2022-09-30 & 18:52:00 & 288911 & BOULE 200G           & 1 & 1,20 €\\\\\n",
       "\t 511389 & 2022-09-30 & 18:52:00 & 288911 & COUPE                & 2 & 0,15 €\\\\\n",
       "\t 511392 & 2022-09-30 & 18:55:00 & 288912 & TRADITIONAL BAGUETTE & 1 & 1,30 €\\\\\n",
       "\t 511395 & 2022-09-30 & 18:56:00 & 288913 & TRADITIONAL BAGUETTE & 1 & 1,30 €\\\\\n",
       "\\end{tabular}\n"
      ],
      "text/markdown": [
       "\n",
       "A spec_tbl_df: 234005 × 7\n",
       "\n",
       "| ...1 &lt;dbl&gt; | date &lt;date&gt; | time &lt;time&gt; | ticket_number &lt;dbl&gt; | article &lt;chr&gt; | Quantity &lt;dbl&gt; | unit_price &lt;chr&gt; |\n",
       "|---|---|---|---|---|---|---|\n",
       "|  0 | 2021-01-02 | 08:38:00 | 150040 | BAGUETTE             | 1 | 0,90 € |\n",
       "|  1 | 2021-01-02 | 08:38:00 | 150040 | PAIN AU CHOCOLAT     | 3 | 1,20 € |\n",
       "|  4 | 2021-01-02 | 09:14:00 | 150041 | PAIN AU CHOCOLAT     | 2 | 1,20 € |\n",
       "|  5 | 2021-01-02 | 09:14:00 | 150041 | PAIN                 | 1 | 1,15 € |\n",
       "|  8 | 2021-01-02 | 09:25:00 | 150042 | TRADITIONAL BAGUETTE | 5 | 1,20 € |\n",
       "| 11 | 2021-01-02 | 09:25:00 | 150043 | BAGUETTE             | 2 | 0,90 € |\n",
       "| 12 | 2021-01-02 | 09:25:00 | 150043 | CROISSANT            | 3 | 1,10 € |\n",
       "| 15 | 2021-01-02 | 09:27:00 | 150044 | BANETTE              | 1 | 1,05 € |\n",
       "| 18 | 2021-01-02 | 09:32:00 | 150045 | TRADITIONAL BAGUETTE | 3 | 1,20 € |\n",
       "| 19 | 2021-01-02 | 09:32:00 | 150045 | CROISSANT            | 6 | 1,10 € |\n",
       "| 22 | 2021-01-02 | 09:37:00 | 150046 | PAIN AU CHOCOLAT     | 6 | 1,20 € |\n",
       "| 23 | 2021-01-02 | 09:37:00 | 150046 | CROISSANT            | 6 | 1,10 € |\n",
       "| 24 | 2021-01-02 | 09:37:00 | 150046 | TRADITIONAL BAGUETTE | 6 | 1,20 € |\n",
       "| 29 | 2021-01-02 | 09:39:00 | 150048 | CROISSANT            | 3 | 1,10 € |\n",
       "| 32 | 2021-01-02 | 09:40:00 | 150049 | CROISSANT            | 2 | 1,10 € |\n",
       "| 33 | 2021-01-02 | 09:40:00 | 150049 | TRADITIONAL BAGUETTE | 1 | 1,20 € |\n",
       "| 36 | 2021-01-02 | 09:41:00 | 150050 | TRADITIONAL BAGUETTE | 2 | 1,20 € |\n",
       "| 39 | 2021-01-02 | 09:46:00 | 150051 | PAIN                 | 1 | 1,15 € |\n",
       "| 42 | 2021-01-02 | 09:48:00 | 150052 | BANETTINE            | 1 | 0,60 € |\n",
       "| 43 | 2021-01-02 | 09:48:00 | 150052 | SPECIAL BREAD        | 1 | 2,40 € |\n",
       "| 44 | 2021-01-02 | 09:48:00 | 150052 | COUPE                | 1 | 0,15 € |\n",
       "| 47 | 2021-01-02 | 09:48:00 | 150053 | TRADITIONAL BAGUETTE | 1 | 1,20 € |\n",
       "| 48 | 2021-01-02 | 09:48:00 | 150053 | SAND JB EMMENTAL     | 2 | 3,50 € |\n",
       "| 51 | 2021-01-02 | 09:49:00 | 150054 | KOUIGN AMANN         | 1 | 2,10 € |\n",
       "| 52 | 2021-01-02 | 09:49:00 | 150054 | PAIN                 | 2 | 1,15 € |\n",
       "| 55 | 2021-01-02 | 09:57:00 | 150055 | TRADITIONAL BAGUETTE | 4 | 1,20 € |\n",
       "| 58 | 2021-01-02 | 09:58:00 | 150056 | BANETTE              | 3 | 1,05 € |\n",
       "| 59 | 2021-01-02 | 09:58:00 | 150056 | CROISSANT            | 5 | 1,10 € |\n",
       "| 64 | 2021-01-02 | 10:03:00 | 150058 | TRADITIONAL BAGUETTE | 2 | 1,20 € |\n",
       "| 65 | 2021-01-02 | 10:03:00 | 150058 | CROISSANT            | 2 | 1,10 € |\n",
       "| ⋮ | ⋮ | ⋮ | ⋮ | ⋮ | ⋮ | ⋮ |\n",
       "| 511324 | 2022-09-30 | 17:19:00 | 288892 | CEREAL BAGUETTE      | 1 | 1,35 € |\n",
       "| 511327 | 2022-09-30 | 17:25:00 | 288893 | CEREAL BAGUETTE      | 1 | 1,35 € |\n",
       "| 511330 | 2022-09-30 | 17:31:00 | 288894 | TRADITIONAL BAGUETTE | 1 | 1,30 € |\n",
       "| 511333 | 2022-09-30 | 17:37:00 | 288895 | TRADITIONAL BAGUETTE | 1 | 1,30 € |\n",
       "| 511336 | 2022-09-30 | 17:41:00 | 288896 | TRADITIONAL BAGUETTE | 1 | 1,30 € |\n",
       "| 511339 | 2022-09-30 | 17:58:00 | 288897 | CAMPAGNE             | 1 | 2,00 € |\n",
       "| 511340 | 2022-09-30 | 17:58:00 | 288897 | COUPE                | 1 | 0,15 € |\n",
       "| 511341 | 2022-09-30 | 17:58:00 | 288897 | ECLAIR               | 1 | 2,20 € |\n",
       "| 511344 | 2022-09-30 | 18:02:00 | 288898 | TRADITIONAL BAGUETTE | 1 | 1,30 € |\n",
       "| 511347 | 2022-09-30 | 18:08:00 | 288899 | TRADITIONAL BAGUETTE | 1 | 1,30 € |\n",
       "| 511350 | 2022-09-30 | 18:17:00 | 288900 | TRADITIONAL BAGUETTE | 4 | 1,30 € |\n",
       "| 511353 | 2022-09-30 | 18:19:00 | 288901 | CARAMEL NOIX         | 1 | 2,40 € |\n",
       "| 511354 | 2022-09-30 | 18:19:00 | 288901 | FLAN                 | 1 | 2,20 € |\n",
       "| 511355 | 2022-09-30 | 18:19:00 | 288901 | TRADITIONAL BAGUETTE | 1 | 1,30 € |\n",
       "| 511358 | 2022-09-30 | 18:22:00 | 288902 | BANETTE              | 1 | 1,15 € |\n",
       "| 511361 | 2022-09-30 | 18:24:00 | 288903 | CEREAL BAGUETTE      | 3 | 1,35 € |\n",
       "| 511362 | 2022-09-30 | 18:24:00 | 288903 | DIVERS CONFISERIE    | 1 | 6,00 € |\n",
       "| 511363 | 2022-09-30 | 18:24:00 | 288903 | TRADITIONAL BAGUETTE | 4 | 1,30 € |\n",
       "| 511368 | 2022-09-30 | 18:26:00 | 288905 | TRADITIONAL BAGUETTE | 1 | 1,30 € |\n",
       "| 511373 | 2022-09-30 | 18:30:00 | 288907 | COUPE                | 1 | 0,15 € |\n",
       "| 511374 | 2022-09-30 | 18:30:00 | 288907 | CAMPAGNE             | 1 | 2,00 € |\n",
       "| 511377 | 2022-09-30 | 18:34:00 | 288908 | CEREAL BAGUETTE      | 2 | 1,35 € |\n",
       "| 511382 | 2022-09-30 | 18:39:00 | 288910 | TRADITIONAL BAGUETTE | 1 | 1,30 € |\n",
       "| 511385 | 2022-09-30 | 18:52:00 | 288911 | CAMPAGNE             | 2 | 2,00 € |\n",
       "| 511386 | 2022-09-30 | 18:52:00 | 288911 | TRADITIONAL BAGUETTE | 5 | 1,30 € |\n",
       "| 511387 | 2022-09-30 | 18:52:00 | 288911 | COUPE                | 1 | 0,15 € |\n",
       "| 511388 | 2022-09-30 | 18:52:00 | 288911 | BOULE 200G           | 1 | 1,20 € |\n",
       "| 511389 | 2022-09-30 | 18:52:00 | 288911 | COUPE                | 2 | 0,15 € |\n",
       "| 511392 | 2022-09-30 | 18:55:00 | 288912 | TRADITIONAL BAGUETTE | 1 | 1,30 € |\n",
       "| 511395 | 2022-09-30 | 18:56:00 | 288913 | TRADITIONAL BAGUETTE | 1 | 1,30 € |\n",
       "\n"
      ],
      "text/plain": [
       "       ...1   date       time     ticket_number article              Quantity\n",
       "1       0     2021-01-02 08:38:00 150040        BAGUETTE             1       \n",
       "2       1     2021-01-02 08:38:00 150040        PAIN AU CHOCOLAT     3       \n",
       "3       4     2021-01-02 09:14:00 150041        PAIN AU CHOCOLAT     2       \n",
       "4       5     2021-01-02 09:14:00 150041        PAIN                 1       \n",
       "5       8     2021-01-02 09:25:00 150042        TRADITIONAL BAGUETTE 5       \n",
       "6      11     2021-01-02 09:25:00 150043        BAGUETTE             2       \n",
       "7      12     2021-01-02 09:25:00 150043        CROISSANT            3       \n",
       "8      15     2021-01-02 09:27:00 150044        BANETTE              1       \n",
       "9      18     2021-01-02 09:32:00 150045        TRADITIONAL BAGUETTE 3       \n",
       "10     19     2021-01-02 09:32:00 150045        CROISSANT            6       \n",
       "11     22     2021-01-02 09:37:00 150046        PAIN AU CHOCOLAT     6       \n",
       "12     23     2021-01-02 09:37:00 150046        CROISSANT            6       \n",
       "13     24     2021-01-02 09:37:00 150046        TRADITIONAL BAGUETTE 6       \n",
       "14     29     2021-01-02 09:39:00 150048        CROISSANT            3       \n",
       "15     32     2021-01-02 09:40:00 150049        CROISSANT            2       \n",
       "16     33     2021-01-02 09:40:00 150049        TRADITIONAL BAGUETTE 1       \n",
       "17     36     2021-01-02 09:41:00 150050        TRADITIONAL BAGUETTE 2       \n",
       "18     39     2021-01-02 09:46:00 150051        PAIN                 1       \n",
       "19     42     2021-01-02 09:48:00 150052        BANETTINE            1       \n",
       "20     43     2021-01-02 09:48:00 150052        SPECIAL BREAD        1       \n",
       "21     44     2021-01-02 09:48:00 150052        COUPE                1       \n",
       "22     47     2021-01-02 09:48:00 150053        TRADITIONAL BAGUETTE 1       \n",
       "23     48     2021-01-02 09:48:00 150053        SAND JB EMMENTAL     2       \n",
       "24     51     2021-01-02 09:49:00 150054        KOUIGN AMANN         1       \n",
       "25     52     2021-01-02 09:49:00 150054        PAIN                 2       \n",
       "26     55     2021-01-02 09:57:00 150055        TRADITIONAL BAGUETTE 4       \n",
       "27     58     2021-01-02 09:58:00 150056        BANETTE              3       \n",
       "28     59     2021-01-02 09:58:00 150056        CROISSANT            5       \n",
       "29     64     2021-01-02 10:03:00 150058        TRADITIONAL BAGUETTE 2       \n",
       "30     65     2021-01-02 10:03:00 150058        CROISSANT            2       \n",
       "⋮      ⋮      ⋮          ⋮        ⋮             ⋮                    ⋮       \n",
       "233976 511324 2022-09-30 17:19:00 288892        CEREAL BAGUETTE      1       \n",
       "233977 511327 2022-09-30 17:25:00 288893        CEREAL BAGUETTE      1       \n",
       "233978 511330 2022-09-30 17:31:00 288894        TRADITIONAL BAGUETTE 1       \n",
       "233979 511333 2022-09-30 17:37:00 288895        TRADITIONAL BAGUETTE 1       \n",
       "233980 511336 2022-09-30 17:41:00 288896        TRADITIONAL BAGUETTE 1       \n",
       "233981 511339 2022-09-30 17:58:00 288897        CAMPAGNE             1       \n",
       "233982 511340 2022-09-30 17:58:00 288897        COUPE                1       \n",
       "233983 511341 2022-09-30 17:58:00 288897        ECLAIR               1       \n",
       "233984 511344 2022-09-30 18:02:00 288898        TRADITIONAL BAGUETTE 1       \n",
       "233985 511347 2022-09-30 18:08:00 288899        TRADITIONAL BAGUETTE 1       \n",
       "233986 511350 2022-09-30 18:17:00 288900        TRADITIONAL BAGUETTE 4       \n",
       "233987 511353 2022-09-30 18:19:00 288901        CARAMEL NOIX         1       \n",
       "233988 511354 2022-09-30 18:19:00 288901        FLAN                 1       \n",
       "233989 511355 2022-09-30 18:19:00 288901        TRADITIONAL BAGUETTE 1       \n",
       "233990 511358 2022-09-30 18:22:00 288902        BANETTE              1       \n",
       "233991 511361 2022-09-30 18:24:00 288903        CEREAL BAGUETTE      3       \n",
       "233992 511362 2022-09-30 18:24:00 288903        DIVERS CONFISERIE    1       \n",
       "233993 511363 2022-09-30 18:24:00 288903        TRADITIONAL BAGUETTE 4       \n",
       "233994 511368 2022-09-30 18:26:00 288905        TRADITIONAL BAGUETTE 1       \n",
       "233995 511373 2022-09-30 18:30:00 288907        COUPE                1       \n",
       "233996 511374 2022-09-30 18:30:00 288907        CAMPAGNE             1       \n",
       "233997 511377 2022-09-30 18:34:00 288908        CEREAL BAGUETTE      2       \n",
       "233998 511382 2022-09-30 18:39:00 288910        TRADITIONAL BAGUETTE 1       \n",
       "233999 511385 2022-09-30 18:52:00 288911        CAMPAGNE             2       \n",
       "234000 511386 2022-09-30 18:52:00 288911        TRADITIONAL BAGUETTE 5       \n",
       "234001 511387 2022-09-30 18:52:00 288911        COUPE                1       \n",
       "234002 511388 2022-09-30 18:52:00 288911        BOULE 200G           1       \n",
       "234003 511389 2022-09-30 18:52:00 288911        COUPE                2       \n",
       "234004 511392 2022-09-30 18:55:00 288912        TRADITIONAL BAGUETTE 1       \n",
       "234005 511395 2022-09-30 18:56:00 288913        TRADITIONAL BAGUETTE 1       \n",
       "       unit_price\n",
       "1      0,90 €    \n",
       "2      1,20 €    \n",
       "3      1,20 €    \n",
       "4      1,15 €    \n",
       "5      1,20 €    \n",
       "6      0,90 €    \n",
       "7      1,10 €    \n",
       "8      1,05 €    \n",
       "9      1,20 €    \n",
       "10     1,10 €    \n",
       "11     1,20 €    \n",
       "12     1,10 €    \n",
       "13     1,20 €    \n",
       "14     1,10 €    \n",
       "15     1,10 €    \n",
       "16     1,20 €    \n",
       "17     1,20 €    \n",
       "18     1,15 €    \n",
       "19     0,60 €    \n",
       "20     2,40 €    \n",
       "21     0,15 €    \n",
       "22     1,20 €    \n",
       "23     3,50 €    \n",
       "24     2,10 €    \n",
       "25     1,15 €    \n",
       "26     1,20 €    \n",
       "27     1,05 €    \n",
       "28     1,10 €    \n",
       "29     1,20 €    \n",
       "30     1,10 €    \n",
       "⋮      ⋮         \n",
       "233976 1,35 €    \n",
       "233977 1,35 €    \n",
       "233978 1,30 €    \n",
       "233979 1,30 €    \n",
       "233980 1,30 €    \n",
       "233981 2,00 €    \n",
       "233982 0,15 €    \n",
       "233983 2,20 €    \n",
       "233984 1,30 €    \n",
       "233985 1,30 €    \n",
       "233986 1,30 €    \n",
       "233987 2,40 €    \n",
       "233988 2,20 €    \n",
       "233989 1,30 €    \n",
       "233990 1,15 €    \n",
       "233991 1,35 €    \n",
       "233992 6,00 €    \n",
       "233993 1,30 €    \n",
       "233994 1,30 €    \n",
       "233995 0,15 €    \n",
       "233996 2,00 €    \n",
       "233997 1,35 €    \n",
       "233998 1,30 €    \n",
       "233999 2,00 €    \n",
       "234000 1,30 €    \n",
       "234001 0,15 €    \n",
       "234002 1,20 €    \n",
       "234003 0,15 €    \n",
       "234004 1,30 €    \n",
       "234005 1,30 €    "
      ]
     },
     "metadata": {},
     "output_type": "display_data"
    }
   ],
   "source": [
    "raw_data <- read_csv(\"/kaggle/input/french-bakery-daily-sales/Bakery sales.csv\")\n",
    "raw_data"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 3,
   "id": "135b27c2",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2024-06-02T22:23:19.102085Z",
     "iopub.status.busy": "2024-06-02T22:23:19.100265Z",
     "iopub.status.idle": "2024-06-02T22:23:19.212092Z",
     "shell.execute_reply": "2024-06-02T22:23:19.210101Z"
    },
    "papermill": {
     "duration": 0.127845,
     "end_time": "2024-06-02T22:23:19.214796",
     "exception": false,
     "start_time": "2024-06-02T22:23:19.086951",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [
    {
     "data": {
      "text/plain": [
       "      ...1             date                time          ticket_number   \n",
       " Min.   :     0   Min.   :2021-01-02   Length:234005     Min.   :150040  \n",
       " 1st Qu.:127979   1st Qu.:2021-07-03   Class1:hms        1st Qu.:184754  \n",
       " Median :254573   Median :2021-11-04   Class2:difftime   Median :218807  \n",
       " Mean   :255205   Mean   :2021-11-30   Mode  :numeric    Mean   :219201  \n",
       " 3rd Qu.:382911   3rd Qu.:2022-05-31                     3rd Qu.:253927  \n",
       " Max.   :511395   Max.   :2022-09-30                     Max.   :288913  \n",
       "   article             Quantity         unit_price       \n",
       " Length:234005      Min.   :-200.000   Length:234005     \n",
       " Class :character   1st Qu.:   1.000   Class :character  \n",
       " Mode  :character   Median :   1.000   Mode  :character  \n",
       "                    Mean   :   1.538                     \n",
       "                    3rd Qu.:   2.000                     \n",
       "                    Max.   : 200.000                     "
      ]
     },
     "metadata": {},
     "output_type": "display_data"
    },
    {
     "data": {
      "text/html": [
       "<table class=\"dataframe\">\n",
       "<caption>A spec_tbl_df: 1 × 1</caption>\n",
       "<thead>\n",
       "\t<tr><th scope=col>n</th></tr>\n",
       "\t<tr><th scope=col>&lt;int&gt;</th></tr>\n",
       "</thead>\n",
       "<tbody>\n",
       "\t<tr><td>1295</td></tr>\n",
       "</tbody>\n",
       "</table>\n"
      ],
      "text/latex": [
       "A spec\\_tbl\\_df: 1 × 1\n",
       "\\begin{tabular}{l}\n",
       " n\\\\\n",
       " <int>\\\\\n",
       "\\hline\n",
       "\t 1295\\\\\n",
       "\\end{tabular}\n"
      ],
      "text/markdown": [
       "\n",
       "A spec_tbl_df: 1 × 1\n",
       "\n",
       "| n &lt;int&gt; |\n",
       "|---|\n",
       "| 1295 |\n",
       "\n"
      ],
      "text/plain": [
       "  n   \n",
       "1 1295"
      ]
     },
     "metadata": {},
     "output_type": "display_data"
    }
   ],
   "source": [
    "summary(raw_data)\n",
    "\n",
    "raw_data %>%\n",
    "  filter(Quantity < 1) %>% \n",
    "  count()"
   ]
  },
  {
   "cell_type": "markdown",
   "id": "9608d82b",
   "metadata": {
    "papermill": {
     "duration": 0.011468,
     "end_time": "2024-06-02T22:23:19.237908",
     "exception": false,
     "start_time": "2024-06-02T22:23:19.226440",
     "status": "completed"
    },
    "tags": []
   },
   "source": [
    "Negative value in Quantity column. It could be a return by miss while ordering. It could be mistake when was collecting data. Assume that this is food product and negative quantity positions not so much. I decide to drop this orders.\n",
    "\n",
    "Make some cleaning"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 4,
   "id": "6b997705",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2024-06-02T22:23:19.264714Z",
     "iopub.status.busy": "2024-06-02T22:23:19.263072Z",
     "iopub.status.idle": "2024-06-02T22:23:19.768820Z",
     "shell.execute_reply": "2024-06-02T22:23:19.765664Z"
    },
    "papermill": {
     "duration": 0.523,
     "end_time": "2024-06-02T22:23:19.772345",
     "exception": false,
     "start_time": "2024-06-02T22:23:19.249345",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [],
   "source": [
    "orders_history <- raw_data %>% \n",
    "  filter(Quantity >  0) %>% \n",
    "  mutate(\n",
    "    article = tolower(article),\n",
    "    year = year(date),\n",
    "    month = month(date),\n",
    "    day = day(date),\n",
    "    unit_price = parse_number(unit_price) / 100,\n",
    "    amount = unit_price * Quantity\n",
    "  ) %>% \n",
    "  rename(\n",
    "    quantity = Quantity\n",
    "  ) %>% \n",
    "  arrange(article)"
   ]
  },
  {
   "cell_type": "markdown",
   "id": "d8cebcbc",
   "metadata": {
    "papermill": {
     "duration": 0.011517,
     "end_time": "2024-06-02T22:23:19.795565",
     "exception": false,
     "start_time": "2024-06-02T22:23:19.784048",
     "status": "completed"
    },
    "tags": []
   },
   "source": [
    "As we can see some orders have missing unit price and some have \"bad\" article. We will drop it. this values not so much."
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 5,
   "id": "9f6e2c50",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2024-06-02T22:23:19.822930Z",
     "iopub.status.busy": "2024-06-02T22:23:19.821183Z",
     "iopub.status.idle": "2024-06-02T22:23:20.070511Z",
     "shell.execute_reply": "2024-06-02T22:23:20.068338Z"
    },
    "papermill": {
     "duration": 0.26636,
     "end_time": "2024-06-02T22:23:20.073364",
     "exception": false,
     "start_time": "2024-06-02T22:23:19.807004",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [
    {
     "data": {
      "text/html": [
       "<table class=\"dataframe\">\n",
       "<caption>A tibble: 31 × 11</caption>\n",
       "<thead>\n",
       "\t<tr><th scope=col>...1</th><th scope=col>date</th><th scope=col>time</th><th scope=col>ticket_number</th><th scope=col>article</th><th scope=col>quantity</th><th scope=col>unit_price</th><th scope=col>year</th><th scope=col>month</th><th scope=col>day</th><th scope=col>amount</th></tr>\n",
       "\t<tr><th scope=col>&lt;dbl&gt;</th><th scope=col>&lt;date&gt;</th><th scope=col>&lt;time&gt;</th><th scope=col>&lt;dbl&gt;</th><th scope=col>&lt;chr&gt;</th><th scope=col>&lt;dbl&gt;</th><th scope=col>&lt;dbl&gt;</th><th scope=col>&lt;dbl&gt;</th><th scope=col>&lt;dbl&gt;</th><th scope=col>&lt;int&gt;</th><th scope=col>&lt;dbl&gt;</th></tr>\n",
       "</thead>\n",
       "<tbody>\n",
       "\t<tr><td> 33726</td><td>2021-03-04</td><td>12:32:00</td><td>159219</td><td>.                  </td><td>2</td><td>0</td><td>2021</td><td> 3</td><td> 4</td><td>0</td></tr>\n",
       "\t<tr><td> 43541</td><td>2021-03-18</td><td>12:59:00</td><td>161853</td><td>.                  </td><td>1</td><td>0</td><td>2021</td><td> 3</td><td>18</td><td>0</td></tr>\n",
       "\t<tr><td> 54650</td><td>2021-04-04</td><td>09:53:00</td><td>164878</td><td>.                  </td><td>1</td><td>0</td><td>2021</td><td> 4</td><td> 4</td><td>0</td></tr>\n",
       "\t<tr><td> 73667</td><td>2021-04-27</td><td>16:48:00</td><td>170079</td><td>.                  </td><td>1</td><td>0</td><td>2021</td><td> 4</td><td>27</td><td>0</td></tr>\n",
       "\t<tr><td>135091</td><td>2021-07-10</td><td>13:25:00</td><td>186662</td><td>.                  </td><td>2</td><td>0</td><td>2021</td><td> 7</td><td>10</td><td>0</td></tr>\n",
       "\t<tr><td>257905</td><td>2021-11-08</td><td>20:00:00</td><td>219725</td><td>article 295        </td><td>1</td><td>0</td><td>2021</td><td>11</td><td> 8</td><td>0</td></tr>\n",
       "\t<tr><td>458906</td><td>2022-08-08</td><td>12:45:00</td><td>274611</td><td>divers boissons    </td><td>1</td><td>0</td><td>2022</td><td> 8</td><td> 8</td><td>0</td></tr>\n",
       "\t<tr><td> 23009</td><td>2021-02-19</td><td>10:13:00</td><td>156355</td><td>divers boulangerie </td><td>1</td><td>0</td><td>2021</td><td> 2</td><td>19</td><td>0</td></tr>\n",
       "\t<tr><td>276219</td><td>2021-12-19</td><td>09:51:00</td><td>224748</td><td>divers boulangerie </td><td>1</td><td>0</td><td>2021</td><td>12</td><td>19</td><td>0</td></tr>\n",
       "\t<tr><td> 87369</td><td>2021-05-13</td><td>11:15:00</td><td>173793</td><td>divers confiserie  </td><td>1</td><td>0</td><td>2021</td><td> 5</td><td>13</td><td>0</td></tr>\n",
       "\t<tr><td>160882</td><td>2021-07-29</td><td>13:06:00</td><td>193530</td><td>divers confiserie  </td><td>1</td><td>0</td><td>2021</td><td> 7</td><td>29</td><td>0</td></tr>\n",
       "\t<tr><td>408792</td><td>2022-07-02</td><td>11:16:00</td><td>261119</td><td>divers confiserie  </td><td>1</td><td>0</td><td>2022</td><td> 7</td><td> 2</td><td>0</td></tr>\n",
       "\t<tr><td>   156</td><td>2021-01-02</td><td>10:51:00</td><td>150079</td><td>divers patisserie  </td><td>1</td><td>0</td><td>2021</td><td> 1</td><td> 2</td><td>0</td></tr>\n",
       "\t<tr><td> 76164</td><td>2021-05-01</td><td>10:17:00</td><td>170776</td><td>divers patisserie  </td><td>1</td><td>0</td><td>2021</td><td> 5</td><td> 1</td><td>0</td></tr>\n",
       "\t<tr><td>187064</td><td>2021-08-16</td><td>12:07:00</td><td>200463</td><td>divers patisserie  </td><td>1</td><td>0</td><td>2021</td><td> 8</td><td>16</td><td>0</td></tr>\n",
       "\t<tr><td>281443</td><td>2021-12-26</td><td>10:55:00</td><td>226147</td><td>divers patisserie  </td><td>1</td><td>0</td><td>2021</td><td>12</td><td>26</td><td>0</td></tr>\n",
       "\t<tr><td>348086</td><td>2022-04-19</td><td>11:18:00</td><td>244433</td><td>divers patisserie  </td><td>1</td><td>0</td><td>2022</td><td> 4</td><td>19</td><td>0</td></tr>\n",
       "\t<tr><td>365519</td><td>2022-05-11</td><td>18:01:00</td><td>249221</td><td>divers patisserie  </td><td>1</td><td>0</td><td>2022</td><td> 5</td><td>11</td><td>0</td></tr>\n",
       "\t<tr><td>408381</td><td>2022-07-02</td><td>09:00:00</td><td>261008</td><td>divers patisserie  </td><td>1</td><td>0</td><td>2022</td><td> 7</td><td> 2</td><td>0</td></tr>\n",
       "\t<tr><td>371631</td><td>2022-05-20</td><td>11:46:00</td><td>250913</td><td>divers sandwichs   </td><td>1</td><td>0</td><td>2022</td><td> 5</td><td>20</td><td>0</td></tr>\n",
       "\t<tr><td>216616</td><td>2021-09-12</td><td>08:04:00</td><td>208431</td><td>divers viennoiserie</td><td>1</td><td>0</td><td>2021</td><td> 9</td><td>12</td><td>0</td></tr>\n",
       "\t<tr><td>236295</td><td>2021-10-10</td><td>10:56:00</td><td>213840</td><td>divers viennoiserie</td><td>1</td><td>0</td><td>2021</td><td>10</td><td>10</td><td>0</td></tr>\n",
       "\t<tr><td> 34951</td><td>2021-03-05</td><td>18:18:00</td><td>159538</td><td>gd far breton      </td><td>1</td><td>0</td><td>2021</td><td> 3</td><td> 5</td><td>0</td></tr>\n",
       "\t<tr><td>341460</td><td>2022-04-11</td><td>12:37:00</td><td>242598</td><td>gd far breton      </td><td>1</td><td>0</td><td>2022</td><td> 4</td><td>11</td><td>0</td></tr>\n",
       "\t<tr><td>351754</td><td>2022-04-23</td><td>11:49:00</td><td>245444</td><td>gd far breton      </td><td>1</td><td>0</td><td>2022</td><td> 4</td><td>23</td><td>0</td></tr>\n",
       "\t<tr><td>408706</td><td>2022-07-02</td><td>10:46:00</td><td>261094</td><td>gd far breton      </td><td>1</td><td>0</td><td>2022</td><td> 7</td><td> 2</td><td>0</td></tr>\n",
       "\t<tr><td>137071</td><td>2021-07-12</td><td>08:25:00</td><td>187148</td><td>platprepare6,50    </td><td>1</td><td>0</td><td>2021</td><td> 7</td><td>12</td><td>0</td></tr>\n",
       "\t<tr><td>152597</td><td>2021-07-23</td><td>12:22:00</td><td>191306</td><td>traiteur           </td><td>1</td><td>0</td><td>2021</td><td> 7</td><td>23</td><td>0</td></tr>\n",
       "\t<tr><td>202224</td><td>2021-08-27</td><td>13:03:00</td><td>204525</td><td>traiteur           </td><td>1</td><td>0</td><td>2021</td><td> 8</td><td>27</td><td>0</td></tr>\n",
       "\t<tr><td>230746</td><td>2021-10-02</td><td>11:06:00</td><td>212340</td><td>traiteur           </td><td>1</td><td>0</td><td>2021</td><td>10</td><td> 2</td><td>0</td></tr>\n",
       "\t<tr><td>293651</td><td>2022-01-18</td><td>11:52:00</td><td>229431</td><td>traiteur           </td><td>1</td><td>0</td><td>2022</td><td> 1</td><td>18</td><td>0</td></tr>\n",
       "</tbody>\n",
       "</table>\n"
      ],
      "text/latex": [
       "A tibble: 31 × 11\n",
       "\\begin{tabular}{lllllllllll}\n",
       " ...1 & date & time & ticket\\_number & article & quantity & unit\\_price & year & month & day & amount\\\\\n",
       " <dbl> & <date> & <time> & <dbl> & <chr> & <dbl> & <dbl> & <dbl> & <dbl> & <int> & <dbl>\\\\\n",
       "\\hline\n",
       "\t  33726 & 2021-03-04 & 12:32:00 & 159219 & .                   & 2 & 0 & 2021 &  3 &  4 & 0\\\\\n",
       "\t  43541 & 2021-03-18 & 12:59:00 & 161853 & .                   & 1 & 0 & 2021 &  3 & 18 & 0\\\\\n",
       "\t  54650 & 2021-04-04 & 09:53:00 & 164878 & .                   & 1 & 0 & 2021 &  4 &  4 & 0\\\\\n",
       "\t  73667 & 2021-04-27 & 16:48:00 & 170079 & .                   & 1 & 0 & 2021 &  4 & 27 & 0\\\\\n",
       "\t 135091 & 2021-07-10 & 13:25:00 & 186662 & .                   & 2 & 0 & 2021 &  7 & 10 & 0\\\\\n",
       "\t 257905 & 2021-11-08 & 20:00:00 & 219725 & article 295         & 1 & 0 & 2021 & 11 &  8 & 0\\\\\n",
       "\t 458906 & 2022-08-08 & 12:45:00 & 274611 & divers boissons     & 1 & 0 & 2022 &  8 &  8 & 0\\\\\n",
       "\t  23009 & 2021-02-19 & 10:13:00 & 156355 & divers boulangerie  & 1 & 0 & 2021 &  2 & 19 & 0\\\\\n",
       "\t 276219 & 2021-12-19 & 09:51:00 & 224748 & divers boulangerie  & 1 & 0 & 2021 & 12 & 19 & 0\\\\\n",
       "\t  87369 & 2021-05-13 & 11:15:00 & 173793 & divers confiserie   & 1 & 0 & 2021 &  5 & 13 & 0\\\\\n",
       "\t 160882 & 2021-07-29 & 13:06:00 & 193530 & divers confiserie   & 1 & 0 & 2021 &  7 & 29 & 0\\\\\n",
       "\t 408792 & 2022-07-02 & 11:16:00 & 261119 & divers confiserie   & 1 & 0 & 2022 &  7 &  2 & 0\\\\\n",
       "\t    156 & 2021-01-02 & 10:51:00 & 150079 & divers patisserie   & 1 & 0 & 2021 &  1 &  2 & 0\\\\\n",
       "\t  76164 & 2021-05-01 & 10:17:00 & 170776 & divers patisserie   & 1 & 0 & 2021 &  5 &  1 & 0\\\\\n",
       "\t 187064 & 2021-08-16 & 12:07:00 & 200463 & divers patisserie   & 1 & 0 & 2021 &  8 & 16 & 0\\\\\n",
       "\t 281443 & 2021-12-26 & 10:55:00 & 226147 & divers patisserie   & 1 & 0 & 2021 & 12 & 26 & 0\\\\\n",
       "\t 348086 & 2022-04-19 & 11:18:00 & 244433 & divers patisserie   & 1 & 0 & 2022 &  4 & 19 & 0\\\\\n",
       "\t 365519 & 2022-05-11 & 18:01:00 & 249221 & divers patisserie   & 1 & 0 & 2022 &  5 & 11 & 0\\\\\n",
       "\t 408381 & 2022-07-02 & 09:00:00 & 261008 & divers patisserie   & 1 & 0 & 2022 &  7 &  2 & 0\\\\\n",
       "\t 371631 & 2022-05-20 & 11:46:00 & 250913 & divers sandwichs    & 1 & 0 & 2022 &  5 & 20 & 0\\\\\n",
       "\t 216616 & 2021-09-12 & 08:04:00 & 208431 & divers viennoiserie & 1 & 0 & 2021 &  9 & 12 & 0\\\\\n",
       "\t 236295 & 2021-10-10 & 10:56:00 & 213840 & divers viennoiserie & 1 & 0 & 2021 & 10 & 10 & 0\\\\\n",
       "\t  34951 & 2021-03-05 & 18:18:00 & 159538 & gd far breton       & 1 & 0 & 2021 &  3 &  5 & 0\\\\\n",
       "\t 341460 & 2022-04-11 & 12:37:00 & 242598 & gd far breton       & 1 & 0 & 2022 &  4 & 11 & 0\\\\\n",
       "\t 351754 & 2022-04-23 & 11:49:00 & 245444 & gd far breton       & 1 & 0 & 2022 &  4 & 23 & 0\\\\\n",
       "\t 408706 & 2022-07-02 & 10:46:00 & 261094 & gd far breton       & 1 & 0 & 2022 &  7 &  2 & 0\\\\\n",
       "\t 137071 & 2021-07-12 & 08:25:00 & 187148 & platprepare6,50     & 1 & 0 & 2021 &  7 & 12 & 0\\\\\n",
       "\t 152597 & 2021-07-23 & 12:22:00 & 191306 & traiteur            & 1 & 0 & 2021 &  7 & 23 & 0\\\\\n",
       "\t 202224 & 2021-08-27 & 13:03:00 & 204525 & traiteur            & 1 & 0 & 2021 &  8 & 27 & 0\\\\\n",
       "\t 230746 & 2021-10-02 & 11:06:00 & 212340 & traiteur            & 1 & 0 & 2021 & 10 &  2 & 0\\\\\n",
       "\t 293651 & 2022-01-18 & 11:52:00 & 229431 & traiteur            & 1 & 0 & 2022 &  1 & 18 & 0\\\\\n",
       "\\end{tabular}\n"
      ],
      "text/markdown": [
       "\n",
       "A tibble: 31 × 11\n",
       "\n",
       "| ...1 &lt;dbl&gt; | date &lt;date&gt; | time &lt;time&gt; | ticket_number &lt;dbl&gt; | article &lt;chr&gt; | quantity &lt;dbl&gt; | unit_price &lt;dbl&gt; | year &lt;dbl&gt; | month &lt;dbl&gt; | day &lt;int&gt; | amount &lt;dbl&gt; |\n",
       "|---|---|---|---|---|---|---|---|---|---|---|\n",
       "|  33726 | 2021-03-04 | 12:32:00 | 159219 | .                   | 2 | 0 | 2021 |  3 |  4 | 0 |\n",
       "|  43541 | 2021-03-18 | 12:59:00 | 161853 | .                   | 1 | 0 | 2021 |  3 | 18 | 0 |\n",
       "|  54650 | 2021-04-04 | 09:53:00 | 164878 | .                   | 1 | 0 | 2021 |  4 |  4 | 0 |\n",
       "|  73667 | 2021-04-27 | 16:48:00 | 170079 | .                   | 1 | 0 | 2021 |  4 | 27 | 0 |\n",
       "| 135091 | 2021-07-10 | 13:25:00 | 186662 | .                   | 2 | 0 | 2021 |  7 | 10 | 0 |\n",
       "| 257905 | 2021-11-08 | 20:00:00 | 219725 | article 295         | 1 | 0 | 2021 | 11 |  8 | 0 |\n",
       "| 458906 | 2022-08-08 | 12:45:00 | 274611 | divers boissons     | 1 | 0 | 2022 |  8 |  8 | 0 |\n",
       "|  23009 | 2021-02-19 | 10:13:00 | 156355 | divers boulangerie  | 1 | 0 | 2021 |  2 | 19 | 0 |\n",
       "| 276219 | 2021-12-19 | 09:51:00 | 224748 | divers boulangerie  | 1 | 0 | 2021 | 12 | 19 | 0 |\n",
       "|  87369 | 2021-05-13 | 11:15:00 | 173793 | divers confiserie   | 1 | 0 | 2021 |  5 | 13 | 0 |\n",
       "| 160882 | 2021-07-29 | 13:06:00 | 193530 | divers confiserie   | 1 | 0 | 2021 |  7 | 29 | 0 |\n",
       "| 408792 | 2022-07-02 | 11:16:00 | 261119 | divers confiserie   | 1 | 0 | 2022 |  7 |  2 | 0 |\n",
       "|    156 | 2021-01-02 | 10:51:00 | 150079 | divers patisserie   | 1 | 0 | 2021 |  1 |  2 | 0 |\n",
       "|  76164 | 2021-05-01 | 10:17:00 | 170776 | divers patisserie   | 1 | 0 | 2021 |  5 |  1 | 0 |\n",
       "| 187064 | 2021-08-16 | 12:07:00 | 200463 | divers patisserie   | 1 | 0 | 2021 |  8 | 16 | 0 |\n",
       "| 281443 | 2021-12-26 | 10:55:00 | 226147 | divers patisserie   | 1 | 0 | 2021 | 12 | 26 | 0 |\n",
       "| 348086 | 2022-04-19 | 11:18:00 | 244433 | divers patisserie   | 1 | 0 | 2022 |  4 | 19 | 0 |\n",
       "| 365519 | 2022-05-11 | 18:01:00 | 249221 | divers patisserie   | 1 | 0 | 2022 |  5 | 11 | 0 |\n",
       "| 408381 | 2022-07-02 | 09:00:00 | 261008 | divers patisserie   | 1 | 0 | 2022 |  7 |  2 | 0 |\n",
       "| 371631 | 2022-05-20 | 11:46:00 | 250913 | divers sandwichs    | 1 | 0 | 2022 |  5 | 20 | 0 |\n",
       "| 216616 | 2021-09-12 | 08:04:00 | 208431 | divers viennoiserie | 1 | 0 | 2021 |  9 | 12 | 0 |\n",
       "| 236295 | 2021-10-10 | 10:56:00 | 213840 | divers viennoiserie | 1 | 0 | 2021 | 10 | 10 | 0 |\n",
       "|  34951 | 2021-03-05 | 18:18:00 | 159538 | gd far breton       | 1 | 0 | 2021 |  3 |  5 | 0 |\n",
       "| 341460 | 2022-04-11 | 12:37:00 | 242598 | gd far breton       | 1 | 0 | 2022 |  4 | 11 | 0 |\n",
       "| 351754 | 2022-04-23 | 11:49:00 | 245444 | gd far breton       | 1 | 0 | 2022 |  4 | 23 | 0 |\n",
       "| 408706 | 2022-07-02 | 10:46:00 | 261094 | gd far breton       | 1 | 0 | 2022 |  7 |  2 | 0 |\n",
       "| 137071 | 2021-07-12 | 08:25:00 | 187148 | platprepare6,50     | 1 | 0 | 2021 |  7 | 12 | 0 |\n",
       "| 152597 | 2021-07-23 | 12:22:00 | 191306 | traiteur            | 1 | 0 | 2021 |  7 | 23 | 0 |\n",
       "| 202224 | 2021-08-27 | 13:03:00 | 204525 | traiteur            | 1 | 0 | 2021 |  8 | 27 | 0 |\n",
       "| 230746 | 2021-10-02 | 11:06:00 | 212340 | traiteur            | 1 | 0 | 2021 | 10 |  2 | 0 |\n",
       "| 293651 | 2022-01-18 | 11:52:00 | 229431 | traiteur            | 1 | 0 | 2022 |  1 | 18 | 0 |\n",
       "\n"
      ],
      "text/plain": [
       "   ...1   date       time     ticket_number article             quantity\n",
       "1   33726 2021-03-04 12:32:00 159219        .                   2       \n",
       "2   43541 2021-03-18 12:59:00 161853        .                   1       \n",
       "3   54650 2021-04-04 09:53:00 164878        .                   1       \n",
       "4   73667 2021-04-27 16:48:00 170079        .                   1       \n",
       "5  135091 2021-07-10 13:25:00 186662        .                   2       \n",
       "6  257905 2021-11-08 20:00:00 219725        article 295         1       \n",
       "7  458906 2022-08-08 12:45:00 274611        divers boissons     1       \n",
       "8   23009 2021-02-19 10:13:00 156355        divers boulangerie  1       \n",
       "9  276219 2021-12-19 09:51:00 224748        divers boulangerie  1       \n",
       "10  87369 2021-05-13 11:15:00 173793        divers confiserie   1       \n",
       "11 160882 2021-07-29 13:06:00 193530        divers confiserie   1       \n",
       "12 408792 2022-07-02 11:16:00 261119        divers confiserie   1       \n",
       "13    156 2021-01-02 10:51:00 150079        divers patisserie   1       \n",
       "14  76164 2021-05-01 10:17:00 170776        divers patisserie   1       \n",
       "15 187064 2021-08-16 12:07:00 200463        divers patisserie   1       \n",
       "16 281443 2021-12-26 10:55:00 226147        divers patisserie   1       \n",
       "17 348086 2022-04-19 11:18:00 244433        divers patisserie   1       \n",
       "18 365519 2022-05-11 18:01:00 249221        divers patisserie   1       \n",
       "19 408381 2022-07-02 09:00:00 261008        divers patisserie   1       \n",
       "20 371631 2022-05-20 11:46:00 250913        divers sandwichs    1       \n",
       "21 216616 2021-09-12 08:04:00 208431        divers viennoiserie 1       \n",
       "22 236295 2021-10-10 10:56:00 213840        divers viennoiserie 1       \n",
       "23  34951 2021-03-05 18:18:00 159538        gd far breton       1       \n",
       "24 341460 2022-04-11 12:37:00 242598        gd far breton       1       \n",
       "25 351754 2022-04-23 11:49:00 245444        gd far breton       1       \n",
       "26 408706 2022-07-02 10:46:00 261094        gd far breton       1       \n",
       "27 137071 2021-07-12 08:25:00 187148        platprepare6,50     1       \n",
       "28 152597 2021-07-23 12:22:00 191306        traiteur            1       \n",
       "29 202224 2021-08-27 13:03:00 204525        traiteur            1       \n",
       "30 230746 2021-10-02 11:06:00 212340        traiteur            1       \n",
       "31 293651 2022-01-18 11:52:00 229431        traiteur            1       \n",
       "   unit_price year month day amount\n",
       "1  0          2021  3     4  0     \n",
       "2  0          2021  3    18  0     \n",
       "3  0          2021  4     4  0     \n",
       "4  0          2021  4    27  0     \n",
       "5  0          2021  7    10  0     \n",
       "6  0          2021 11     8  0     \n",
       "7  0          2022  8     8  0     \n",
       "8  0          2021  2    19  0     \n",
       "9  0          2021 12    19  0     \n",
       "10 0          2021  5    13  0     \n",
       "11 0          2021  7    29  0     \n",
       "12 0          2022  7     2  0     \n",
       "13 0          2021  1     2  0     \n",
       "14 0          2021  5     1  0     \n",
       "15 0          2021  8    16  0     \n",
       "16 0          2021 12    26  0     \n",
       "17 0          2022  4    19  0     \n",
       "18 0          2022  5    11  0     \n",
       "19 0          2022  7     2  0     \n",
       "20 0          2022  5    20  0     \n",
       "21 0          2021  9    12  0     \n",
       "22 0          2021 10    10  0     \n",
       "23 0          2021  3     5  0     \n",
       "24 0          2022  4    11  0     \n",
       "25 0          2022  4    23  0     \n",
       "26 0          2022  7     2  0     \n",
       "27 0          2021  7    12  0     \n",
       "28 0          2021  7    23  0     \n",
       "29 0          2021  8    27  0     \n",
       "30 0          2021 10     2  0     \n",
       "31 0          2022  1    18  0     "
      ]
     },
     "metadata": {},
     "output_type": "display_data"
    }
   ],
   "source": [
    "orders_history %>% \n",
    "  filter(unit_price < 0.01)\n",
    "\n",
    "orders_history <- orders_history %>% \n",
    "  filter(unit_price > 0.01)"
   ]
  },
  {
   "cell_type": "markdown",
   "id": "273ad964",
   "metadata": {
    "papermill": {
     "duration": 0.012242,
     "end_time": "2024-06-02T22:23:20.097774",
     "exception": false,
     "start_time": "2024-06-02T22:23:20.085532",
     "status": "completed"
    },
    "tags": []
   },
   "source": [
    "Some unusual orders. It strange when one order includes 43 baguette. It could be b2b order instead of b2c or order for bunch of people. I will keep it in table because there only 9 orders like this.\n",
    "\n",
    "if there were more such orders, most likely this would mean that you need to devote time to studying b2b interaction"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 6,
   "id": "5790156d",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2024-06-02T22:23:20.126068Z",
     "iopub.status.busy": "2024-06-02T22:23:20.124368Z",
     "iopub.status.idle": "2024-06-02T22:23:20.178637Z",
     "shell.execute_reply": "2024-06-02T22:23:20.176694Z"
    },
    "papermill": {
     "duration": 0.071307,
     "end_time": "2024-06-02T22:23:20.181356",
     "exception": false,
     "start_time": "2024-06-02T22:23:20.110049",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [
    {
     "data": {
      "text/html": [
       "<table class=\"dataframe\">\n",
       "<caption>A tibble: 9 × 11</caption>\n",
       "<thead>\n",
       "\t<tr><th scope=col>...1</th><th scope=col>date</th><th scope=col>time</th><th scope=col>ticket_number</th><th scope=col>article</th><th scope=col>quantity</th><th scope=col>unit_price</th><th scope=col>year</th><th scope=col>month</th><th scope=col>day</th><th scope=col>amount</th></tr>\n",
       "\t<tr><th scope=col>&lt;dbl&gt;</th><th scope=col>&lt;date&gt;</th><th scope=col>&lt;time&gt;</th><th scope=col>&lt;dbl&gt;</th><th scope=col>&lt;chr&gt;</th><th scope=col>&lt;dbl&gt;</th><th scope=col>&lt;dbl&gt;</th><th scope=col>&lt;dbl&gt;</th><th scope=col>&lt;dbl&gt;</th><th scope=col>&lt;int&gt;</th><th scope=col>&lt;dbl&gt;</th></tr>\n",
       "</thead>\n",
       "<tbody>\n",
       "\t<tr><td>257472</td><td>2021-11-08</td><td>10:03:00</td><td>219600</td><td>baguette            </td><td> 43</td><td>0.90</td><td>2021</td><td>11</td><td> 8</td><td> 38.70</td></tr>\n",
       "\t<tr><td>258031</td><td>2021-11-09</td><td>10:19:00</td><td>219760</td><td>baguette            </td><td> 25</td><td>0.90</td><td>2021</td><td>11</td><td> 9</td><td> 22.50</td></tr>\n",
       "\t<tr><td>110375</td><td>2021-06-12</td><td>09:58:00</td><td>179931</td><td>cafe ou eau         </td><td>200</td><td>1.00</td><td>2021</td><td> 6</td><td>12</td><td>200.00</td></tr>\n",
       "\t<tr><td>162235</td><td>2021-07-30</td><td>17:07:00</td><td>193898</td><td>coupe               </td><td> 25</td><td>0.15</td><td>2021</td><td> 7</td><td>30</td><td>  3.75</td></tr>\n",
       "\t<tr><td>194741</td><td>2021-08-22</td><td>08:16:00</td><td>202518</td><td>croissant           </td><td> 25</td><td>1.10</td><td>2021</td><td> 8</td><td>22</td><td> 27.50</td></tr>\n",
       "\t<tr><td>434863</td><td>2022-07-23</td><td>10:26:00</td><td>268154</td><td>pain                </td><td> 50</td><td>1.30</td><td>2022</td><td> 7</td><td>23</td><td> 65.00</td></tr>\n",
       "\t<tr><td>152338</td><td>2021-07-23</td><td>11:26:00</td><td>191236</td><td>tartelette          </td><td> 25</td><td>2.00</td><td>2021</td><td> 7</td><td>23</td><td> 50.00</td></tr>\n",
       "\t<tr><td>241700</td><td>2021-10-19</td><td>16:43:00</td><td>215345</td><td>traditional baguette</td><td> 25</td><td>1.20</td><td>2021</td><td>10</td><td>19</td><td> 30.00</td></tr>\n",
       "\t<tr><td>250844</td><td>2021-10-31</td><td>10:42:00</td><td>217821</td><td>traditional baguette</td><td> 55</td><td>1.20</td><td>2021</td><td>10</td><td>31</td><td> 66.00</td></tr>\n",
       "</tbody>\n",
       "</table>\n"
      ],
      "text/latex": [
       "A tibble: 9 × 11\n",
       "\\begin{tabular}{lllllllllll}\n",
       " ...1 & date & time & ticket\\_number & article & quantity & unit\\_price & year & month & day & amount\\\\\n",
       " <dbl> & <date> & <time> & <dbl> & <chr> & <dbl> & <dbl> & <dbl> & <dbl> & <int> & <dbl>\\\\\n",
       "\\hline\n",
       "\t 257472 & 2021-11-08 & 10:03:00 & 219600 & baguette             &  43 & 0.90 & 2021 & 11 &  8 &  38.70\\\\\n",
       "\t 258031 & 2021-11-09 & 10:19:00 & 219760 & baguette             &  25 & 0.90 & 2021 & 11 &  9 &  22.50\\\\\n",
       "\t 110375 & 2021-06-12 & 09:58:00 & 179931 & cafe ou eau          & 200 & 1.00 & 2021 &  6 & 12 & 200.00\\\\\n",
       "\t 162235 & 2021-07-30 & 17:07:00 & 193898 & coupe                &  25 & 0.15 & 2021 &  7 & 30 &   3.75\\\\\n",
       "\t 194741 & 2021-08-22 & 08:16:00 & 202518 & croissant            &  25 & 1.10 & 2021 &  8 & 22 &  27.50\\\\\n",
       "\t 434863 & 2022-07-23 & 10:26:00 & 268154 & pain                 &  50 & 1.30 & 2022 &  7 & 23 &  65.00\\\\\n",
       "\t 152338 & 2021-07-23 & 11:26:00 & 191236 & tartelette           &  25 & 2.00 & 2021 &  7 & 23 &  50.00\\\\\n",
       "\t 241700 & 2021-10-19 & 16:43:00 & 215345 & traditional baguette &  25 & 1.20 & 2021 & 10 & 19 &  30.00\\\\\n",
       "\t 250844 & 2021-10-31 & 10:42:00 & 217821 & traditional baguette &  55 & 1.20 & 2021 & 10 & 31 &  66.00\\\\\n",
       "\\end{tabular}\n"
      ],
      "text/markdown": [
       "\n",
       "A tibble: 9 × 11\n",
       "\n",
       "| ...1 &lt;dbl&gt; | date &lt;date&gt; | time &lt;time&gt; | ticket_number &lt;dbl&gt; | article &lt;chr&gt; | quantity &lt;dbl&gt; | unit_price &lt;dbl&gt; | year &lt;dbl&gt; | month &lt;dbl&gt; | day &lt;int&gt; | amount &lt;dbl&gt; |\n",
       "|---|---|---|---|---|---|---|---|---|---|---|\n",
       "| 257472 | 2021-11-08 | 10:03:00 | 219600 | baguette             |  43 | 0.90 | 2021 | 11 |  8 |  38.70 |\n",
       "| 258031 | 2021-11-09 | 10:19:00 | 219760 | baguette             |  25 | 0.90 | 2021 | 11 |  9 |  22.50 |\n",
       "| 110375 | 2021-06-12 | 09:58:00 | 179931 | cafe ou eau          | 200 | 1.00 | 2021 |  6 | 12 | 200.00 |\n",
       "| 162235 | 2021-07-30 | 17:07:00 | 193898 | coupe                |  25 | 0.15 | 2021 |  7 | 30 |   3.75 |\n",
       "| 194741 | 2021-08-22 | 08:16:00 | 202518 | croissant            |  25 | 1.10 | 2021 |  8 | 22 |  27.50 |\n",
       "| 434863 | 2022-07-23 | 10:26:00 | 268154 | pain                 |  50 | 1.30 | 2022 |  7 | 23 |  65.00 |\n",
       "| 152338 | 2021-07-23 | 11:26:00 | 191236 | tartelette           |  25 | 2.00 | 2021 |  7 | 23 |  50.00 |\n",
       "| 241700 | 2021-10-19 | 16:43:00 | 215345 | traditional baguette |  25 | 1.20 | 2021 | 10 | 19 |  30.00 |\n",
       "| 250844 | 2021-10-31 | 10:42:00 | 217821 | traditional baguette |  55 | 1.20 | 2021 | 10 | 31 |  66.00 |\n",
       "\n"
      ],
      "text/plain": [
       "  ...1   date       time     ticket_number article              quantity\n",
       "1 257472 2021-11-08 10:03:00 219600        baguette              43     \n",
       "2 258031 2021-11-09 10:19:00 219760        baguette              25     \n",
       "3 110375 2021-06-12 09:58:00 179931        cafe ou eau          200     \n",
       "4 162235 2021-07-30 17:07:00 193898        coupe                 25     \n",
       "5 194741 2021-08-22 08:16:00 202518        croissant             25     \n",
       "6 434863 2022-07-23 10:26:00 268154        pain                  50     \n",
       "7 152338 2021-07-23 11:26:00 191236        tartelette            25     \n",
       "8 241700 2021-10-19 16:43:00 215345        traditional baguette  25     \n",
       "9 250844 2021-10-31 10:42:00 217821        traditional baguette  55     \n",
       "  unit_price year month day amount\n",
       "1 0.90       2021 11     8   38.70\n",
       "2 0.90       2021 11     9   22.50\n",
       "3 1.00       2021  6    12  200.00\n",
       "4 0.15       2021  7    30    3.75\n",
       "5 1.10       2021  8    22   27.50\n",
       "6 1.30       2022  7    23   65.00\n",
       "7 2.00       2021  7    23   50.00\n",
       "8 1.20       2021 10    19   30.00\n",
       "9 1.20       2021 10    31   66.00"
      ]
     },
     "metadata": {},
     "output_type": "display_data"
    }
   ],
   "source": [
    "orders_history %>% \n",
    "  filter(quantity > 20) %>% \n",
    "  distinct(ticket_number, .keep_all = TRUE)"
   ]
  },
  {
   "cell_type": "markdown",
   "id": "3320a55d",
   "metadata": {
    "papermill": {
     "duration": 0.012683,
     "end_time": "2024-06-02T22:23:20.206687",
     "exception": false,
     "start_time": "2024-06-02T22:23:20.194004",
     "status": "completed"
    },
    "tags": []
   },
   "source": [
    "Here some problem. Some of out tickets have same meaning, but different article. We will fix it later."
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 7,
   "id": "1937d349",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2024-06-02T22:23:20.236605Z",
     "iopub.status.busy": "2024-06-02T22:23:20.234871Z",
     "iopub.status.idle": "2024-06-02T22:23:20.464160Z",
     "shell.execute_reply": "2024-06-02T22:23:20.462125Z"
    },
    "papermill": {
     "duration": 0.246856,
     "end_time": "2024-06-02T22:23:20.466952",
     "exception": false,
     "start_time": "2024-06-02T22:23:20.220096",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [
    {
     "data": {
      "text/html": [
       "<table class=\"dataframe\">\n",
       "<caption>A tibble: 1558 × 11</caption>\n",
       "<thead>\n",
       "\t<tr><th scope=col>...1</th><th scope=col>date</th><th scope=col>time</th><th scope=col>ticket_number</th><th scope=col>article</th><th scope=col>quantity</th><th scope=col>unit_price</th><th scope=col>year</th><th scope=col>month</th><th scope=col>day</th><th scope=col>amount</th></tr>\n",
       "\t<tr><th scope=col>&lt;dbl&gt;</th><th scope=col>&lt;date&gt;</th><th scope=col>&lt;time&gt;</th><th scope=col>&lt;dbl&gt;</th><th scope=col>&lt;chr&gt;</th><th scope=col>&lt;dbl&gt;</th><th scope=col>&lt;dbl&gt;</th><th scope=col>&lt;dbl&gt;</th><th scope=col>&lt;dbl&gt;</th><th scope=col>&lt;int&gt;</th><th scope=col>&lt;dbl&gt;</th></tr>\n",
       "</thead>\n",
       "<tbody>\n",
       "\t<tr><td>279403</td><td>2021-12-24</td><td>09:28:00</td><td>225670</td><td>buche 4pers      </td><td>1</td><td>14</td><td>2021</td><td>12</td><td>24</td><td>14</td></tr>\n",
       "\t<tr><td>279902</td><td>2021-12-24</td><td>11:28:00</td><td>225783</td><td>buche 4pers      </td><td>1</td><td>14</td><td>2021</td><td>12</td><td>24</td><td>14</td></tr>\n",
       "\t<tr><td>280065</td><td>2021-12-24</td><td>12:11:00</td><td>225820</td><td>buche 4pers      </td><td>1</td><td>14</td><td>2021</td><td>12</td><td>24</td><td>14</td></tr>\n",
       "\t<tr><td>280341</td><td>2021-12-24</td><td>16:57:00</td><td>225883</td><td>buche 4pers      </td><td>1</td><td>14</td><td>2021</td><td>12</td><td>24</td><td>14</td></tr>\n",
       "\t<tr><td>280357</td><td>2021-12-24</td><td>17:19:00</td><td>225887</td><td>buche 4pers      </td><td>1</td><td>14</td><td>2021</td><td>12</td><td>24</td><td>14</td></tr>\n",
       "\t<tr><td>280548</td><td>2021-12-25</td><td>09:18:00</td><td>225926</td><td>buche 4pers      </td><td>1</td><td>14</td><td>2021</td><td>12</td><td>25</td><td>14</td></tr>\n",
       "\t<tr><td>280754</td><td>2021-12-25</td><td>10:57:00</td><td>225975</td><td>buche 4pers      </td><td>1</td><td>14</td><td>2021</td><td>12</td><td>25</td><td>14</td></tr>\n",
       "\t<tr><td>280827</td><td>2021-12-25</td><td>11:14:00</td><td>225994</td><td>buche 4pers      </td><td>1</td><td>14</td><td>2021</td><td>12</td><td>25</td><td>14</td></tr>\n",
       "\t<tr><td>280954</td><td>2021-12-25</td><td>12:03:00</td><td>226026</td><td>buche 4pers      </td><td>2</td><td>14</td><td>2021</td><td>12</td><td>25</td><td>28</td></tr>\n",
       "\t<tr><td>281442</td><td>2021-12-26</td><td>10:55:00</td><td>226147</td><td>buche 4pers      </td><td>1</td><td>14</td><td>2021</td><td>12</td><td>26</td><td>14</td></tr>\n",
       "\t<tr><td>279405</td><td>2021-12-24</td><td>09:28:00</td><td>225670</td><td>buche 6pers      </td><td>1</td><td>21</td><td>2021</td><td>12</td><td>24</td><td>21</td></tr>\n",
       "\t<tr><td>280064</td><td>2021-12-24</td><td>12:11:00</td><td>225820</td><td>buche 6pers      </td><td>1</td><td>21</td><td>2021</td><td>12</td><td>24</td><td>21</td></tr>\n",
       "\t<tr><td>280277</td><td>2021-12-24</td><td>16:30:00</td><td>225868</td><td>buche 6pers      </td><td>1</td><td>21</td><td>2021</td><td>12</td><td>24</td><td>21</td></tr>\n",
       "\t<tr><td>280373</td><td>2021-12-24</td><td>17:24:00</td><td>225890</td><td>buche 6pers      </td><td>1</td><td>21</td><td>2021</td><td>12</td><td>24</td><td>21</td></tr>\n",
       "\t<tr><td>280598</td><td>2021-12-25</td><td>09:51:00</td><td>225937</td><td>buche 6pers      </td><td>1</td><td>21</td><td>2021</td><td>12</td><td>25</td><td>21</td></tr>\n",
       "\t<tr><td>280892</td><td>2021-12-25</td><td>11:45:00</td><td>226012</td><td>buche 6pers      </td><td>1</td><td>21</td><td>2021</td><td>12</td><td>25</td><td>21</td></tr>\n",
       "\t<tr><td>280919</td><td>2021-12-25</td><td>11:52:00</td><td>226018</td><td>buche 6pers      </td><td>1</td><td>21</td><td>2021</td><td>12</td><td>25</td><td>21</td></tr>\n",
       "\t<tr><td>281746</td><td>2021-12-26</td><td>12:01:00</td><td>226221</td><td>buche 6pers      </td><td>1</td><td>21</td><td>2021</td><td>12</td><td>26</td><td>21</td></tr>\n",
       "\t<tr><td>279818</td><td>2021-12-24</td><td>11:10:00</td><td>225766</td><td>buche 8pers      </td><td>2</td><td>28</td><td>2021</td><td>12</td><td>24</td><td>56</td></tr>\n",
       "\t<tr><td>   158</td><td>2021-01-02</td><td>10:51:00</td><td>150079</td><td>gal frangipane 4p</td><td>1</td><td> 8</td><td>2021</td><td> 1</td><td> 2</td><td> 8</td></tr>\n",
       "\t<tr><td>   388</td><td>2021-01-02</td><td>12:10:00</td><td>150138</td><td>gal frangipane 4p</td><td>1</td><td> 8</td><td>2021</td><td> 1</td><td> 2</td><td> 8</td></tr>\n",
       "\t<tr><td>   421</td><td>2021-01-02</td><td>12:19:00</td><td>150147</td><td>gal frangipane 4p</td><td>2</td><td> 8</td><td>2021</td><td> 1</td><td> 2</td><td>16</td></tr>\n",
       "\t<tr><td>   465</td><td>2021-01-02</td><td>12:28:00</td><td>150159</td><td>gal frangipane 4p</td><td>1</td><td> 8</td><td>2021</td><td> 1</td><td> 2</td><td> 8</td></tr>\n",
       "\t<tr><td>   479</td><td>2021-01-02</td><td>12:32:00</td><td>150162</td><td>gal frangipane 4p</td><td>1</td><td> 8</td><td>2021</td><td> 1</td><td> 2</td><td> 8</td></tr>\n",
       "\t<tr><td>   494</td><td>2021-01-02</td><td>12:36:00</td><td>150165</td><td>gal frangipane 4p</td><td>1</td><td> 8</td><td>2021</td><td> 1</td><td> 2</td><td> 8</td></tr>\n",
       "\t<tr><td>   547</td><td>2021-01-02</td><td>12:44:00</td><td>150179</td><td>gal frangipane 4p</td><td>1</td><td> 8</td><td>2021</td><td> 1</td><td> 2</td><td> 8</td></tr>\n",
       "\t<tr><td>   757</td><td>2021-01-03</td><td>09:19:00</td><td>150232</td><td>gal frangipane 4p</td><td>1</td><td> 8</td><td>2021</td><td> 1</td><td> 3</td><td> 8</td></tr>\n",
       "\t<tr><td>   768</td><td>2021-01-03</td><td>09:28:00</td><td>150234</td><td>gal frangipane 4p</td><td>1</td><td> 8</td><td>2021</td><td> 1</td><td> 3</td><td> 8</td></tr>\n",
       "\t<tr><td>   821</td><td>2021-01-03</td><td>09:53:00</td><td>150247</td><td>gal frangipane 4p</td><td>1</td><td> 8</td><td>2021</td><td> 1</td><td> 3</td><td> 8</td></tr>\n",
       "\t<tr><td>   832</td><td>2021-01-03</td><td>09:59:00</td><td>150249</td><td>gal frangipane 4p</td><td>1</td><td> 8</td><td>2021</td><td> 1</td><td> 3</td><td> 8</td></tr>\n",
       "\t<tr><td>⋮</td><td>⋮</td><td>⋮</td><td>⋮</td><td>⋮</td><td>⋮</td><td>⋮</td><td>⋮</td><td>⋮</td><td>⋮</td><td>⋮</td></tr>\n",
       "\t<tr><td>434680</td><td>2022-07-23</td><td>09:44:00</td><td>268103</td><td>tarte fruits 6p</td><td>1</td><td>14</td><td>2022</td><td>7</td><td>23</td><td>14</td></tr>\n",
       "\t<tr><td>434877</td><td>2022-07-23</td><td>10:32:00</td><td>268158</td><td>tarte fruits 6p</td><td>1</td><td>14</td><td>2022</td><td>7</td><td>23</td><td>14</td></tr>\n",
       "\t<tr><td>435023</td><td>2022-07-23</td><td>11:07:00</td><td>268196</td><td>tarte fruits 6p</td><td>1</td><td>14</td><td>2022</td><td>7</td><td>23</td><td>14</td></tr>\n",
       "\t<tr><td>444950</td><td>2022-07-30</td><td>12:31:00</td><td>270886</td><td>tarte fruits 6p</td><td>1</td><td>14</td><td>2022</td><td>7</td><td>30</td><td>14</td></tr>\n",
       "\t<tr><td>445877</td><td>2022-07-31</td><td>09:46:00</td><td>271121</td><td>tarte fruits 6p</td><td>2</td><td>14</td><td>2022</td><td>7</td><td>31</td><td>28</td></tr>\n",
       "\t<tr><td>446154</td><td>2022-07-31</td><td>10:26:00</td><td>271191</td><td>tarte fruits 6p</td><td>1</td><td>14</td><td>2022</td><td>7</td><td>31</td><td>14</td></tr>\n",
       "\t<tr><td>456361</td><td>2022-08-07</td><td>09:52:00</td><td>273924</td><td>tarte fruits 6p</td><td>1</td><td>14</td><td>2022</td><td>8</td><td> 7</td><td>14</td></tr>\n",
       "\t<tr><td>465687</td><td>2022-08-13</td><td>09:15:00</td><td>276438</td><td>tarte fruits 6p</td><td>1</td><td>14</td><td>2022</td><td>8</td><td>13</td><td>14</td></tr>\n",
       "\t<tr><td>466254</td><td>2022-08-13</td><td>11:00:00</td><td>276592</td><td>tarte fruits 6p</td><td>1</td><td>14</td><td>2022</td><td>8</td><td>13</td><td>14</td></tr>\n",
       "\t<tr><td>467009</td><td>2022-08-14</td><td>07:53:00</td><td>276809</td><td>tarte fruits 6p</td><td>1</td><td>14</td><td>2022</td><td>8</td><td>14</td><td>14</td></tr>\n",
       "\t<tr><td>467151</td><td>2022-08-14</td><td>08:26:00</td><td>276840</td><td>tarte fruits 6p</td><td>1</td><td>14</td><td>2022</td><td>8</td><td>14</td><td>14</td></tr>\n",
       "\t<tr><td>467340</td><td>2022-08-14</td><td>09:00:00</td><td>276881</td><td>tarte fruits 6p</td><td>1</td><td>14</td><td>2022</td><td>8</td><td>14</td><td>14</td></tr>\n",
       "\t<tr><td>469805</td><td>2022-08-15</td><td>10:16:00</td><td>277517</td><td>tarte fruits 6p</td><td>1</td><td>14</td><td>2022</td><td>8</td><td>15</td><td>14</td></tr>\n",
       "\t<tr><td>469832</td><td>2022-08-15</td><td>10:19:00</td><td>277523</td><td>tarte fruits 6p</td><td>1</td><td>14</td><td>2022</td><td>8</td><td>15</td><td>14</td></tr>\n",
       "\t<tr><td>470607</td><td>2022-08-15</td><td>12:32:00</td><td>277731</td><td>tarte fruits 6p</td><td>1</td><td>14</td><td>2022</td><td>8</td><td>15</td><td>14</td></tr>\n",
       "\t<tr><td>476867</td><td>2022-08-20</td><td>09:24:00</td><td>279442</td><td>tarte fruits 6p</td><td>1</td><td>14</td><td>2022</td><td>8</td><td>20</td><td>14</td></tr>\n",
       "\t<tr><td>476998</td><td>2022-08-20</td><td>09:49:00</td><td>279475</td><td>tarte fruits 6p</td><td>1</td><td>14</td><td>2022</td><td>8</td><td>20</td><td>14</td></tr>\n",
       "\t<tr><td>477398</td><td>2022-08-20</td><td>11:10:00</td><td>279582</td><td>tarte fruits 6p</td><td>1</td><td>14</td><td>2022</td><td>8</td><td>20</td><td>14</td></tr>\n",
       "\t<tr><td>478751</td><td>2022-08-21</td><td>09:59:00</td><td>279927</td><td>tarte fruits 6p</td><td>1</td><td>14</td><td>2022</td><td>8</td><td>21</td><td>14</td></tr>\n",
       "\t<tr><td>486556</td><td>2022-08-27</td><td>11:27:00</td><td>282070</td><td>tarte fruits 6p</td><td>1</td><td>14</td><td>2022</td><td>8</td><td>27</td><td>14</td></tr>\n",
       "\t<tr><td>488022</td><td>2022-08-28</td><td>11:36:00</td><td>282457</td><td>tarte fruits 6p</td><td>1</td><td>14</td><td>2022</td><td>8</td><td>28</td><td>14</td></tr>\n",
       "\t<tr><td>492647</td><td>2022-09-04</td><td>09:27:00</td><td>283734</td><td>tarte fruits 6p</td><td>1</td><td>14</td><td>2022</td><td>9</td><td> 4</td><td>14</td></tr>\n",
       "\t<tr><td>493771</td><td>2022-09-05</td><td>10:47:00</td><td>284048</td><td>tarte fruits 6p</td><td>1</td><td>14</td><td>2022</td><td>9</td><td> 5</td><td>14</td></tr>\n",
       "\t<tr><td>497867</td><td>2022-09-11</td><td>09:37:00</td><td>285169</td><td>tarte fruits 6p</td><td>1</td><td>14</td><td>2022</td><td>9</td><td>11</td><td>14</td></tr>\n",
       "\t<tr><td>501987</td><td>2022-09-17</td><td>09:02:00</td><td>286317</td><td>tarte fruits 6p</td><td>1</td><td>14</td><td>2022</td><td>9</td><td>17</td><td>14</td></tr>\n",
       "\t<tr><td>502247</td><td>2022-09-17</td><td>11:16:00</td><td>286384</td><td>tarte fruits 6p</td><td>1</td><td>14</td><td>2022</td><td>9</td><td>17</td><td>14</td></tr>\n",
       "\t<tr><td>503580</td><td>2022-09-18</td><td>12:03:00</td><td>286729</td><td>tarte fruits 6p</td><td>1</td><td>14</td><td>2022</td><td>9</td><td>18</td><td>14</td></tr>\n",
       "\t<tr><td>506948</td><td>2022-09-25</td><td>08:27:00</td><td>287676</td><td>tarte fruits 6p</td><td>1</td><td>14</td><td>2022</td><td>9</td><td>25</td><td>14</td></tr>\n",
       "\t<tr><td>507077</td><td>2022-09-25</td><td>09:20:00</td><td>287704</td><td>tarte fruits 6p</td><td>1</td><td>14</td><td>2022</td><td>9</td><td>25</td><td>14</td></tr>\n",
       "\t<tr><td>507197</td><td>2022-09-25</td><td>10:04:00</td><td>287736</td><td>tarte fruits 6p</td><td>1</td><td>14</td><td>2022</td><td>9</td><td>25</td><td>14</td></tr>\n",
       "</tbody>\n",
       "</table>\n"
      ],
      "text/latex": [
       "A tibble: 1558 × 11\n",
       "\\begin{tabular}{lllllllllll}\n",
       " ...1 & date & time & ticket\\_number & article & quantity & unit\\_price & year & month & day & amount\\\\\n",
       " <dbl> & <date> & <time> & <dbl> & <chr> & <dbl> & <dbl> & <dbl> & <dbl> & <int> & <dbl>\\\\\n",
       "\\hline\n",
       "\t 279403 & 2021-12-24 & 09:28:00 & 225670 & buche 4pers       & 1 & 14 & 2021 & 12 & 24 & 14\\\\\n",
       "\t 279902 & 2021-12-24 & 11:28:00 & 225783 & buche 4pers       & 1 & 14 & 2021 & 12 & 24 & 14\\\\\n",
       "\t 280065 & 2021-12-24 & 12:11:00 & 225820 & buche 4pers       & 1 & 14 & 2021 & 12 & 24 & 14\\\\\n",
       "\t 280341 & 2021-12-24 & 16:57:00 & 225883 & buche 4pers       & 1 & 14 & 2021 & 12 & 24 & 14\\\\\n",
       "\t 280357 & 2021-12-24 & 17:19:00 & 225887 & buche 4pers       & 1 & 14 & 2021 & 12 & 24 & 14\\\\\n",
       "\t 280548 & 2021-12-25 & 09:18:00 & 225926 & buche 4pers       & 1 & 14 & 2021 & 12 & 25 & 14\\\\\n",
       "\t 280754 & 2021-12-25 & 10:57:00 & 225975 & buche 4pers       & 1 & 14 & 2021 & 12 & 25 & 14\\\\\n",
       "\t 280827 & 2021-12-25 & 11:14:00 & 225994 & buche 4pers       & 1 & 14 & 2021 & 12 & 25 & 14\\\\\n",
       "\t 280954 & 2021-12-25 & 12:03:00 & 226026 & buche 4pers       & 2 & 14 & 2021 & 12 & 25 & 28\\\\\n",
       "\t 281442 & 2021-12-26 & 10:55:00 & 226147 & buche 4pers       & 1 & 14 & 2021 & 12 & 26 & 14\\\\\n",
       "\t 279405 & 2021-12-24 & 09:28:00 & 225670 & buche 6pers       & 1 & 21 & 2021 & 12 & 24 & 21\\\\\n",
       "\t 280064 & 2021-12-24 & 12:11:00 & 225820 & buche 6pers       & 1 & 21 & 2021 & 12 & 24 & 21\\\\\n",
       "\t 280277 & 2021-12-24 & 16:30:00 & 225868 & buche 6pers       & 1 & 21 & 2021 & 12 & 24 & 21\\\\\n",
       "\t 280373 & 2021-12-24 & 17:24:00 & 225890 & buche 6pers       & 1 & 21 & 2021 & 12 & 24 & 21\\\\\n",
       "\t 280598 & 2021-12-25 & 09:51:00 & 225937 & buche 6pers       & 1 & 21 & 2021 & 12 & 25 & 21\\\\\n",
       "\t 280892 & 2021-12-25 & 11:45:00 & 226012 & buche 6pers       & 1 & 21 & 2021 & 12 & 25 & 21\\\\\n",
       "\t 280919 & 2021-12-25 & 11:52:00 & 226018 & buche 6pers       & 1 & 21 & 2021 & 12 & 25 & 21\\\\\n",
       "\t 281746 & 2021-12-26 & 12:01:00 & 226221 & buche 6pers       & 1 & 21 & 2021 & 12 & 26 & 21\\\\\n",
       "\t 279818 & 2021-12-24 & 11:10:00 & 225766 & buche 8pers       & 2 & 28 & 2021 & 12 & 24 & 56\\\\\n",
       "\t    158 & 2021-01-02 & 10:51:00 & 150079 & gal frangipane 4p & 1 &  8 & 2021 &  1 &  2 &  8\\\\\n",
       "\t    388 & 2021-01-02 & 12:10:00 & 150138 & gal frangipane 4p & 1 &  8 & 2021 &  1 &  2 &  8\\\\\n",
       "\t    421 & 2021-01-02 & 12:19:00 & 150147 & gal frangipane 4p & 2 &  8 & 2021 &  1 &  2 & 16\\\\\n",
       "\t    465 & 2021-01-02 & 12:28:00 & 150159 & gal frangipane 4p & 1 &  8 & 2021 &  1 &  2 &  8\\\\\n",
       "\t    479 & 2021-01-02 & 12:32:00 & 150162 & gal frangipane 4p & 1 &  8 & 2021 &  1 &  2 &  8\\\\\n",
       "\t    494 & 2021-01-02 & 12:36:00 & 150165 & gal frangipane 4p & 1 &  8 & 2021 &  1 &  2 &  8\\\\\n",
       "\t    547 & 2021-01-02 & 12:44:00 & 150179 & gal frangipane 4p & 1 &  8 & 2021 &  1 &  2 &  8\\\\\n",
       "\t    757 & 2021-01-03 & 09:19:00 & 150232 & gal frangipane 4p & 1 &  8 & 2021 &  1 &  3 &  8\\\\\n",
       "\t    768 & 2021-01-03 & 09:28:00 & 150234 & gal frangipane 4p & 1 &  8 & 2021 &  1 &  3 &  8\\\\\n",
       "\t    821 & 2021-01-03 & 09:53:00 & 150247 & gal frangipane 4p & 1 &  8 & 2021 &  1 &  3 &  8\\\\\n",
       "\t    832 & 2021-01-03 & 09:59:00 & 150249 & gal frangipane 4p & 1 &  8 & 2021 &  1 &  3 &  8\\\\\n",
       "\t ⋮ & ⋮ & ⋮ & ⋮ & ⋮ & ⋮ & ⋮ & ⋮ & ⋮ & ⋮ & ⋮\\\\\n",
       "\t 434680 & 2022-07-23 & 09:44:00 & 268103 & tarte fruits 6p & 1 & 14 & 2022 & 7 & 23 & 14\\\\\n",
       "\t 434877 & 2022-07-23 & 10:32:00 & 268158 & tarte fruits 6p & 1 & 14 & 2022 & 7 & 23 & 14\\\\\n",
       "\t 435023 & 2022-07-23 & 11:07:00 & 268196 & tarte fruits 6p & 1 & 14 & 2022 & 7 & 23 & 14\\\\\n",
       "\t 444950 & 2022-07-30 & 12:31:00 & 270886 & tarte fruits 6p & 1 & 14 & 2022 & 7 & 30 & 14\\\\\n",
       "\t 445877 & 2022-07-31 & 09:46:00 & 271121 & tarte fruits 6p & 2 & 14 & 2022 & 7 & 31 & 28\\\\\n",
       "\t 446154 & 2022-07-31 & 10:26:00 & 271191 & tarte fruits 6p & 1 & 14 & 2022 & 7 & 31 & 14\\\\\n",
       "\t 456361 & 2022-08-07 & 09:52:00 & 273924 & tarte fruits 6p & 1 & 14 & 2022 & 8 &  7 & 14\\\\\n",
       "\t 465687 & 2022-08-13 & 09:15:00 & 276438 & tarte fruits 6p & 1 & 14 & 2022 & 8 & 13 & 14\\\\\n",
       "\t 466254 & 2022-08-13 & 11:00:00 & 276592 & tarte fruits 6p & 1 & 14 & 2022 & 8 & 13 & 14\\\\\n",
       "\t 467009 & 2022-08-14 & 07:53:00 & 276809 & tarte fruits 6p & 1 & 14 & 2022 & 8 & 14 & 14\\\\\n",
       "\t 467151 & 2022-08-14 & 08:26:00 & 276840 & tarte fruits 6p & 1 & 14 & 2022 & 8 & 14 & 14\\\\\n",
       "\t 467340 & 2022-08-14 & 09:00:00 & 276881 & tarte fruits 6p & 1 & 14 & 2022 & 8 & 14 & 14\\\\\n",
       "\t 469805 & 2022-08-15 & 10:16:00 & 277517 & tarte fruits 6p & 1 & 14 & 2022 & 8 & 15 & 14\\\\\n",
       "\t 469832 & 2022-08-15 & 10:19:00 & 277523 & tarte fruits 6p & 1 & 14 & 2022 & 8 & 15 & 14\\\\\n",
       "\t 470607 & 2022-08-15 & 12:32:00 & 277731 & tarte fruits 6p & 1 & 14 & 2022 & 8 & 15 & 14\\\\\n",
       "\t 476867 & 2022-08-20 & 09:24:00 & 279442 & tarte fruits 6p & 1 & 14 & 2022 & 8 & 20 & 14\\\\\n",
       "\t 476998 & 2022-08-20 & 09:49:00 & 279475 & tarte fruits 6p & 1 & 14 & 2022 & 8 & 20 & 14\\\\\n",
       "\t 477398 & 2022-08-20 & 11:10:00 & 279582 & tarte fruits 6p & 1 & 14 & 2022 & 8 & 20 & 14\\\\\n",
       "\t 478751 & 2022-08-21 & 09:59:00 & 279927 & tarte fruits 6p & 1 & 14 & 2022 & 8 & 21 & 14\\\\\n",
       "\t 486556 & 2022-08-27 & 11:27:00 & 282070 & tarte fruits 6p & 1 & 14 & 2022 & 8 & 27 & 14\\\\\n",
       "\t 488022 & 2022-08-28 & 11:36:00 & 282457 & tarte fruits 6p & 1 & 14 & 2022 & 8 & 28 & 14\\\\\n",
       "\t 492647 & 2022-09-04 & 09:27:00 & 283734 & tarte fruits 6p & 1 & 14 & 2022 & 9 &  4 & 14\\\\\n",
       "\t 493771 & 2022-09-05 & 10:47:00 & 284048 & tarte fruits 6p & 1 & 14 & 2022 & 9 &  5 & 14\\\\\n",
       "\t 497867 & 2022-09-11 & 09:37:00 & 285169 & tarte fruits 6p & 1 & 14 & 2022 & 9 & 11 & 14\\\\\n",
       "\t 501987 & 2022-09-17 & 09:02:00 & 286317 & tarte fruits 6p & 1 & 14 & 2022 & 9 & 17 & 14\\\\\n",
       "\t 502247 & 2022-09-17 & 11:16:00 & 286384 & tarte fruits 6p & 1 & 14 & 2022 & 9 & 17 & 14\\\\\n",
       "\t 503580 & 2022-09-18 & 12:03:00 & 286729 & tarte fruits 6p & 1 & 14 & 2022 & 9 & 18 & 14\\\\\n",
       "\t 506948 & 2022-09-25 & 08:27:00 & 287676 & tarte fruits 6p & 1 & 14 & 2022 & 9 & 25 & 14\\\\\n",
       "\t 507077 & 2022-09-25 & 09:20:00 & 287704 & tarte fruits 6p & 1 & 14 & 2022 & 9 & 25 & 14\\\\\n",
       "\t 507197 & 2022-09-25 & 10:04:00 & 287736 & tarte fruits 6p & 1 & 14 & 2022 & 9 & 25 & 14\\\\\n",
       "\\end{tabular}\n"
      ],
      "text/markdown": [
       "\n",
       "A tibble: 1558 × 11\n",
       "\n",
       "| ...1 &lt;dbl&gt; | date &lt;date&gt; | time &lt;time&gt; | ticket_number &lt;dbl&gt; | article &lt;chr&gt; | quantity &lt;dbl&gt; | unit_price &lt;dbl&gt; | year &lt;dbl&gt; | month &lt;dbl&gt; | day &lt;int&gt; | amount &lt;dbl&gt; |\n",
       "|---|---|---|---|---|---|---|---|---|---|---|\n",
       "| 279403 | 2021-12-24 | 09:28:00 | 225670 | buche 4pers       | 1 | 14 | 2021 | 12 | 24 | 14 |\n",
       "| 279902 | 2021-12-24 | 11:28:00 | 225783 | buche 4pers       | 1 | 14 | 2021 | 12 | 24 | 14 |\n",
       "| 280065 | 2021-12-24 | 12:11:00 | 225820 | buche 4pers       | 1 | 14 | 2021 | 12 | 24 | 14 |\n",
       "| 280341 | 2021-12-24 | 16:57:00 | 225883 | buche 4pers       | 1 | 14 | 2021 | 12 | 24 | 14 |\n",
       "| 280357 | 2021-12-24 | 17:19:00 | 225887 | buche 4pers       | 1 | 14 | 2021 | 12 | 24 | 14 |\n",
       "| 280548 | 2021-12-25 | 09:18:00 | 225926 | buche 4pers       | 1 | 14 | 2021 | 12 | 25 | 14 |\n",
       "| 280754 | 2021-12-25 | 10:57:00 | 225975 | buche 4pers       | 1 | 14 | 2021 | 12 | 25 | 14 |\n",
       "| 280827 | 2021-12-25 | 11:14:00 | 225994 | buche 4pers       | 1 | 14 | 2021 | 12 | 25 | 14 |\n",
       "| 280954 | 2021-12-25 | 12:03:00 | 226026 | buche 4pers       | 2 | 14 | 2021 | 12 | 25 | 28 |\n",
       "| 281442 | 2021-12-26 | 10:55:00 | 226147 | buche 4pers       | 1 | 14 | 2021 | 12 | 26 | 14 |\n",
       "| 279405 | 2021-12-24 | 09:28:00 | 225670 | buche 6pers       | 1 | 21 | 2021 | 12 | 24 | 21 |\n",
       "| 280064 | 2021-12-24 | 12:11:00 | 225820 | buche 6pers       | 1 | 21 | 2021 | 12 | 24 | 21 |\n",
       "| 280277 | 2021-12-24 | 16:30:00 | 225868 | buche 6pers       | 1 | 21 | 2021 | 12 | 24 | 21 |\n",
       "| 280373 | 2021-12-24 | 17:24:00 | 225890 | buche 6pers       | 1 | 21 | 2021 | 12 | 24 | 21 |\n",
       "| 280598 | 2021-12-25 | 09:51:00 | 225937 | buche 6pers       | 1 | 21 | 2021 | 12 | 25 | 21 |\n",
       "| 280892 | 2021-12-25 | 11:45:00 | 226012 | buche 6pers       | 1 | 21 | 2021 | 12 | 25 | 21 |\n",
       "| 280919 | 2021-12-25 | 11:52:00 | 226018 | buche 6pers       | 1 | 21 | 2021 | 12 | 25 | 21 |\n",
       "| 281746 | 2021-12-26 | 12:01:00 | 226221 | buche 6pers       | 1 | 21 | 2021 | 12 | 26 | 21 |\n",
       "| 279818 | 2021-12-24 | 11:10:00 | 225766 | buche 8pers       | 2 | 28 | 2021 | 12 | 24 | 56 |\n",
       "|    158 | 2021-01-02 | 10:51:00 | 150079 | gal frangipane 4p | 1 |  8 | 2021 |  1 |  2 |  8 |\n",
       "|    388 | 2021-01-02 | 12:10:00 | 150138 | gal frangipane 4p | 1 |  8 | 2021 |  1 |  2 |  8 |\n",
       "|    421 | 2021-01-02 | 12:19:00 | 150147 | gal frangipane 4p | 2 |  8 | 2021 |  1 |  2 | 16 |\n",
       "|    465 | 2021-01-02 | 12:28:00 | 150159 | gal frangipane 4p | 1 |  8 | 2021 |  1 |  2 |  8 |\n",
       "|    479 | 2021-01-02 | 12:32:00 | 150162 | gal frangipane 4p | 1 |  8 | 2021 |  1 |  2 |  8 |\n",
       "|    494 | 2021-01-02 | 12:36:00 | 150165 | gal frangipane 4p | 1 |  8 | 2021 |  1 |  2 |  8 |\n",
       "|    547 | 2021-01-02 | 12:44:00 | 150179 | gal frangipane 4p | 1 |  8 | 2021 |  1 |  2 |  8 |\n",
       "|    757 | 2021-01-03 | 09:19:00 | 150232 | gal frangipane 4p | 1 |  8 | 2021 |  1 |  3 |  8 |\n",
       "|    768 | 2021-01-03 | 09:28:00 | 150234 | gal frangipane 4p | 1 |  8 | 2021 |  1 |  3 |  8 |\n",
       "|    821 | 2021-01-03 | 09:53:00 | 150247 | gal frangipane 4p | 1 |  8 | 2021 |  1 |  3 |  8 |\n",
       "|    832 | 2021-01-03 | 09:59:00 | 150249 | gal frangipane 4p | 1 |  8 | 2021 |  1 |  3 |  8 |\n",
       "| ⋮ | ⋮ | ⋮ | ⋮ | ⋮ | ⋮ | ⋮ | ⋮ | ⋮ | ⋮ | ⋮ |\n",
       "| 434680 | 2022-07-23 | 09:44:00 | 268103 | tarte fruits 6p | 1 | 14 | 2022 | 7 | 23 | 14 |\n",
       "| 434877 | 2022-07-23 | 10:32:00 | 268158 | tarte fruits 6p | 1 | 14 | 2022 | 7 | 23 | 14 |\n",
       "| 435023 | 2022-07-23 | 11:07:00 | 268196 | tarte fruits 6p | 1 | 14 | 2022 | 7 | 23 | 14 |\n",
       "| 444950 | 2022-07-30 | 12:31:00 | 270886 | tarte fruits 6p | 1 | 14 | 2022 | 7 | 30 | 14 |\n",
       "| 445877 | 2022-07-31 | 09:46:00 | 271121 | tarte fruits 6p | 2 | 14 | 2022 | 7 | 31 | 28 |\n",
       "| 446154 | 2022-07-31 | 10:26:00 | 271191 | tarte fruits 6p | 1 | 14 | 2022 | 7 | 31 | 14 |\n",
       "| 456361 | 2022-08-07 | 09:52:00 | 273924 | tarte fruits 6p | 1 | 14 | 2022 | 8 |  7 | 14 |\n",
       "| 465687 | 2022-08-13 | 09:15:00 | 276438 | tarte fruits 6p | 1 | 14 | 2022 | 8 | 13 | 14 |\n",
       "| 466254 | 2022-08-13 | 11:00:00 | 276592 | tarte fruits 6p | 1 | 14 | 2022 | 8 | 13 | 14 |\n",
       "| 467009 | 2022-08-14 | 07:53:00 | 276809 | tarte fruits 6p | 1 | 14 | 2022 | 8 | 14 | 14 |\n",
       "| 467151 | 2022-08-14 | 08:26:00 | 276840 | tarte fruits 6p | 1 | 14 | 2022 | 8 | 14 | 14 |\n",
       "| 467340 | 2022-08-14 | 09:00:00 | 276881 | tarte fruits 6p | 1 | 14 | 2022 | 8 | 14 | 14 |\n",
       "| 469805 | 2022-08-15 | 10:16:00 | 277517 | tarte fruits 6p | 1 | 14 | 2022 | 8 | 15 | 14 |\n",
       "| 469832 | 2022-08-15 | 10:19:00 | 277523 | tarte fruits 6p | 1 | 14 | 2022 | 8 | 15 | 14 |\n",
       "| 470607 | 2022-08-15 | 12:32:00 | 277731 | tarte fruits 6p | 1 | 14 | 2022 | 8 | 15 | 14 |\n",
       "| 476867 | 2022-08-20 | 09:24:00 | 279442 | tarte fruits 6p | 1 | 14 | 2022 | 8 | 20 | 14 |\n",
       "| 476998 | 2022-08-20 | 09:49:00 | 279475 | tarte fruits 6p | 1 | 14 | 2022 | 8 | 20 | 14 |\n",
       "| 477398 | 2022-08-20 | 11:10:00 | 279582 | tarte fruits 6p | 1 | 14 | 2022 | 8 | 20 | 14 |\n",
       "| 478751 | 2022-08-21 | 09:59:00 | 279927 | tarte fruits 6p | 1 | 14 | 2022 | 8 | 21 | 14 |\n",
       "| 486556 | 2022-08-27 | 11:27:00 | 282070 | tarte fruits 6p | 1 | 14 | 2022 | 8 | 27 | 14 |\n",
       "| 488022 | 2022-08-28 | 11:36:00 | 282457 | tarte fruits 6p | 1 | 14 | 2022 | 8 | 28 | 14 |\n",
       "| 492647 | 2022-09-04 | 09:27:00 | 283734 | tarte fruits 6p | 1 | 14 | 2022 | 9 |  4 | 14 |\n",
       "| 493771 | 2022-09-05 | 10:47:00 | 284048 | tarte fruits 6p | 1 | 14 | 2022 | 9 |  5 | 14 |\n",
       "| 497867 | 2022-09-11 | 09:37:00 | 285169 | tarte fruits 6p | 1 | 14 | 2022 | 9 | 11 | 14 |\n",
       "| 501987 | 2022-09-17 | 09:02:00 | 286317 | tarte fruits 6p | 1 | 14 | 2022 | 9 | 17 | 14 |\n",
       "| 502247 | 2022-09-17 | 11:16:00 | 286384 | tarte fruits 6p | 1 | 14 | 2022 | 9 | 17 | 14 |\n",
       "| 503580 | 2022-09-18 | 12:03:00 | 286729 | tarte fruits 6p | 1 | 14 | 2022 | 9 | 18 | 14 |\n",
       "| 506948 | 2022-09-25 | 08:27:00 | 287676 | tarte fruits 6p | 1 | 14 | 2022 | 9 | 25 | 14 |\n",
       "| 507077 | 2022-09-25 | 09:20:00 | 287704 | tarte fruits 6p | 1 | 14 | 2022 | 9 | 25 | 14 |\n",
       "| 507197 | 2022-09-25 | 10:04:00 | 287736 | tarte fruits 6p | 1 | 14 | 2022 | 9 | 25 | 14 |\n",
       "\n"
      ],
      "text/plain": [
       "     ...1   date       time     ticket_number article           quantity\n",
       "1    279403 2021-12-24 09:28:00 225670        buche 4pers       1       \n",
       "2    279902 2021-12-24 11:28:00 225783        buche 4pers       1       \n",
       "3    280065 2021-12-24 12:11:00 225820        buche 4pers       1       \n",
       "4    280341 2021-12-24 16:57:00 225883        buche 4pers       1       \n",
       "5    280357 2021-12-24 17:19:00 225887        buche 4pers       1       \n",
       "6    280548 2021-12-25 09:18:00 225926        buche 4pers       1       \n",
       "7    280754 2021-12-25 10:57:00 225975        buche 4pers       1       \n",
       "8    280827 2021-12-25 11:14:00 225994        buche 4pers       1       \n",
       "9    280954 2021-12-25 12:03:00 226026        buche 4pers       2       \n",
       "10   281442 2021-12-26 10:55:00 226147        buche 4pers       1       \n",
       "11   279405 2021-12-24 09:28:00 225670        buche 6pers       1       \n",
       "12   280064 2021-12-24 12:11:00 225820        buche 6pers       1       \n",
       "13   280277 2021-12-24 16:30:00 225868        buche 6pers       1       \n",
       "14   280373 2021-12-24 17:24:00 225890        buche 6pers       1       \n",
       "15   280598 2021-12-25 09:51:00 225937        buche 6pers       1       \n",
       "16   280892 2021-12-25 11:45:00 226012        buche 6pers       1       \n",
       "17   280919 2021-12-25 11:52:00 226018        buche 6pers       1       \n",
       "18   281746 2021-12-26 12:01:00 226221        buche 6pers       1       \n",
       "19   279818 2021-12-24 11:10:00 225766        buche 8pers       2       \n",
       "20      158 2021-01-02 10:51:00 150079        gal frangipane 4p 1       \n",
       "21      388 2021-01-02 12:10:00 150138        gal frangipane 4p 1       \n",
       "22      421 2021-01-02 12:19:00 150147        gal frangipane 4p 2       \n",
       "23      465 2021-01-02 12:28:00 150159        gal frangipane 4p 1       \n",
       "24      479 2021-01-02 12:32:00 150162        gal frangipane 4p 1       \n",
       "25      494 2021-01-02 12:36:00 150165        gal frangipane 4p 1       \n",
       "26      547 2021-01-02 12:44:00 150179        gal frangipane 4p 1       \n",
       "27      757 2021-01-03 09:19:00 150232        gal frangipane 4p 1       \n",
       "28      768 2021-01-03 09:28:00 150234        gal frangipane 4p 1       \n",
       "29      821 2021-01-03 09:53:00 150247        gal frangipane 4p 1       \n",
       "30      832 2021-01-03 09:59:00 150249        gal frangipane 4p 1       \n",
       "⋮    ⋮      ⋮          ⋮        ⋮             ⋮                 ⋮       \n",
       "1529 434680 2022-07-23 09:44:00 268103        tarte fruits 6p   1       \n",
       "1530 434877 2022-07-23 10:32:00 268158        tarte fruits 6p   1       \n",
       "1531 435023 2022-07-23 11:07:00 268196        tarte fruits 6p   1       \n",
       "1532 444950 2022-07-30 12:31:00 270886        tarte fruits 6p   1       \n",
       "1533 445877 2022-07-31 09:46:00 271121        tarte fruits 6p   2       \n",
       "1534 446154 2022-07-31 10:26:00 271191        tarte fruits 6p   1       \n",
       "1535 456361 2022-08-07 09:52:00 273924        tarte fruits 6p   1       \n",
       "1536 465687 2022-08-13 09:15:00 276438        tarte fruits 6p   1       \n",
       "1537 466254 2022-08-13 11:00:00 276592        tarte fruits 6p   1       \n",
       "1538 467009 2022-08-14 07:53:00 276809        tarte fruits 6p   1       \n",
       "1539 467151 2022-08-14 08:26:00 276840        tarte fruits 6p   1       \n",
       "1540 467340 2022-08-14 09:00:00 276881        tarte fruits 6p   1       \n",
       "1541 469805 2022-08-15 10:16:00 277517        tarte fruits 6p   1       \n",
       "1542 469832 2022-08-15 10:19:00 277523        tarte fruits 6p   1       \n",
       "1543 470607 2022-08-15 12:32:00 277731        tarte fruits 6p   1       \n",
       "1544 476867 2022-08-20 09:24:00 279442        tarte fruits 6p   1       \n",
       "1545 476998 2022-08-20 09:49:00 279475        tarte fruits 6p   1       \n",
       "1546 477398 2022-08-20 11:10:00 279582        tarte fruits 6p   1       \n",
       "1547 478751 2022-08-21 09:59:00 279927        tarte fruits 6p   1       \n",
       "1548 486556 2022-08-27 11:27:00 282070        tarte fruits 6p   1       \n",
       "1549 488022 2022-08-28 11:36:00 282457        tarte fruits 6p   1       \n",
       "1550 492647 2022-09-04 09:27:00 283734        tarte fruits 6p   1       \n",
       "1551 493771 2022-09-05 10:47:00 284048        tarte fruits 6p   1       \n",
       "1552 497867 2022-09-11 09:37:00 285169        tarte fruits 6p   1       \n",
       "1553 501987 2022-09-17 09:02:00 286317        tarte fruits 6p   1       \n",
       "1554 502247 2022-09-17 11:16:00 286384        tarte fruits 6p   1       \n",
       "1555 503580 2022-09-18 12:03:00 286729        tarte fruits 6p   1       \n",
       "1556 506948 2022-09-25 08:27:00 287676        tarte fruits 6p   1       \n",
       "1557 507077 2022-09-25 09:20:00 287704        tarte fruits 6p   1       \n",
       "1558 507197 2022-09-25 10:04:00 287736        tarte fruits 6p   1       \n",
       "     unit_price year month day amount\n",
       "1    14         2021 12    24  14    \n",
       "2    14         2021 12    24  14    \n",
       "3    14         2021 12    24  14    \n",
       "4    14         2021 12    24  14    \n",
       "5    14         2021 12    24  14    \n",
       "6    14         2021 12    25  14    \n",
       "7    14         2021 12    25  14    \n",
       "8    14         2021 12    25  14    \n",
       "9    14         2021 12    25  28    \n",
       "10   14         2021 12    26  14    \n",
       "11   21         2021 12    24  21    \n",
       "12   21         2021 12    24  21    \n",
       "13   21         2021 12    24  21    \n",
       "14   21         2021 12    24  21    \n",
       "15   21         2021 12    25  21    \n",
       "16   21         2021 12    25  21    \n",
       "17   21         2021 12    25  21    \n",
       "18   21         2021 12    26  21    \n",
       "19   28         2021 12    24  56    \n",
       "20    8         2021  1     2   8    \n",
       "21    8         2021  1     2   8    \n",
       "22    8         2021  1     2  16    \n",
       "23    8         2021  1     2   8    \n",
       "24    8         2021  1     2   8    \n",
       "25    8         2021  1     2   8    \n",
       "26    8         2021  1     2   8    \n",
       "27    8         2021  1     3   8    \n",
       "28    8         2021  1     3   8    \n",
       "29    8         2021  1     3   8    \n",
       "30    8         2021  1     3   8    \n",
       "⋮    ⋮          ⋮    ⋮     ⋮   ⋮     \n",
       "1529 14         2022 7     23  14    \n",
       "1530 14         2022 7     23  14    \n",
       "1531 14         2022 7     23  14    \n",
       "1532 14         2022 7     30  14    \n",
       "1533 14         2022 7     31  28    \n",
       "1534 14         2022 7     31  14    \n",
       "1535 14         2022 8      7  14    \n",
       "1536 14         2022 8     13  14    \n",
       "1537 14         2022 8     13  14    \n",
       "1538 14         2022 8     14  14    \n",
       "1539 14         2022 8     14  14    \n",
       "1540 14         2022 8     14  14    \n",
       "1541 14         2022 8     15  14    \n",
       "1542 14         2022 8     15  14    \n",
       "1543 14         2022 8     15  14    \n",
       "1544 14         2022 8     20  14    \n",
       "1545 14         2022 8     20  14    \n",
       "1546 14         2022 8     20  14    \n",
       "1547 14         2022 8     21  14    \n",
       "1548 14         2022 8     27  14    \n",
       "1549 14         2022 8     28  14    \n",
       "1550 14         2022 9      4  14    \n",
       "1551 14         2022 9      5  14    \n",
       "1552 14         2022 9     11  14    \n",
       "1553 14         2022 9     17  14    \n",
       "1554 14         2022 9     17  14    \n",
       "1555 14         2022 9     18  14    \n",
       "1556 14         2022 9     25  14    \n",
       "1557 14         2022 9     25  14    \n",
       "1558 14         2022 9     25  14    "
      ]
     },
     "metadata": {},
     "output_type": "display_data"
    }
   ],
   "source": [
    "problem_data <- orders_history %>% \n",
    "  filter(str_detect(article, '[0-9][pP]'))\n",
    "\n",
    "problem_data"
   ]
  },
  {
   "cell_type": "markdown",
   "id": "4793b980",
   "metadata": {
    "papermill": {
     "duration": 0.013368,
     "end_time": "2024-06-02T22:23:20.494243",
     "exception": false,
     "start_time": "2024-06-02T22:23:20.480875",
     "status": "completed"
    },
    "tags": []
   },
   "source": [
    "As we can see, the number of orders decreased by 16K. However, this is because we initially overlooked that our data spans from January 1, 2021, to September 30, 2022. If we filter the data to only include the first nine months of each year, the difference appears smaller. Despite this, the order count in 2022 still shows a decline, which is concerning."
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 8,
   "id": "a4ec2498",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2024-06-02T22:23:20.525086Z",
     "iopub.status.busy": "2024-06-02T22:23:20.523314Z",
     "iopub.status.idle": "2024-06-02T22:23:20.811073Z",
     "shell.execute_reply": "2024-06-02T22:23:20.809025Z"
    },
    "papermill": {
     "duration": 0.306505,
     "end_time": "2024-06-02T22:23:20.813961",
     "exception": false,
     "start_time": "2024-06-02T22:23:20.507456",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [
    {
     "data": {
      "text/html": [
       "<table class=\"dataframe\">\n",
       "<caption>A tibble: 2 × 2</caption>\n",
       "<thead>\n",
       "\t<tr><th scope=col>year</th><th scope=col>n</th></tr>\n",
       "\t<tr><th scope=col>&lt;dbl&gt;</th><th scope=col>&lt;int&gt;</th></tr>\n",
       "</thead>\n",
       "<tbody>\n",
       "\t<tr><td>2021</td><td>75758</td></tr>\n",
       "\t<tr><td>2022</td><td>59927</td></tr>\n",
       "</tbody>\n",
       "</table>\n"
      ],
      "text/latex": [
       "A tibble: 2 × 2\n",
       "\\begin{tabular}{ll}\n",
       " year & n\\\\\n",
       " <dbl> & <int>\\\\\n",
       "\\hline\n",
       "\t 2021 & 75758\\\\\n",
       "\t 2022 & 59927\\\\\n",
       "\\end{tabular}\n"
      ],
      "text/markdown": [
       "\n",
       "A tibble: 2 × 2\n",
       "\n",
       "| year &lt;dbl&gt; | n &lt;int&gt; |\n",
       "|---|---|\n",
       "| 2021 | 75758 |\n",
       "| 2022 | 59927 |\n",
       "\n"
      ],
      "text/plain": [
       "  year n    \n",
       "1 2021 75758\n",
       "2 2022 59927"
      ]
     },
     "metadata": {},
     "output_type": "display_data"
    },
    {
     "data": {
      "text/html": [
       "<table class=\"dataframe\">\n",
       "<caption>A tibble: 2 × 2</caption>\n",
       "<thead>\n",
       "\t<tr><th scope=col>year</th><th scope=col>n</th></tr>\n",
       "\t<tr><th scope=col>&lt;dbl&gt;</th><th scope=col>&lt;int&gt;</th></tr>\n",
       "</thead>\n",
       "<tbody>\n",
       "\t<tr><td>2021</td><td>61032</td></tr>\n",
       "\t<tr><td>2022</td><td>59927</td></tr>\n",
       "</tbody>\n",
       "</table>\n"
      ],
      "text/latex": [
       "A tibble: 2 × 2\n",
       "\\begin{tabular}{ll}\n",
       " year & n\\\\\n",
       " <dbl> & <int>\\\\\n",
       "\\hline\n",
       "\t 2021 & 61032\\\\\n",
       "\t 2022 & 59927\\\\\n",
       "\\end{tabular}\n"
      ],
      "text/markdown": [
       "\n",
       "A tibble: 2 × 2\n",
       "\n",
       "| year &lt;dbl&gt; | n &lt;int&gt; |\n",
       "|---|---|\n",
       "| 2021 | 61032 |\n",
       "| 2022 | 59927 |\n",
       "\n"
      ],
      "text/plain": [
       "  year n    \n",
       "1 2021 61032\n",
       "2 2022 59927"
      ]
     },
     "metadata": {},
     "output_type": "display_data"
    }
   ],
   "source": [
    "orders_history %>% \n",
    "  distinct(ticket_number, .keep_all = TRUE) %>% \n",
    "  count(year)\n",
    "\n",
    "orders_history %>% \n",
    "  filter(between(month, 1, 9)) %>% \n",
    "  distinct(ticket_number, .keep_all = TRUE) %>% \n",
    "  count(year)"
   ]
  },
  {
   "cell_type": "markdown",
   "id": "9fcc555b",
   "metadata": {
    "papermill": {
     "duration": 0.01377,
     "end_time": "2024-06-02T22:23:20.841549",
     "exception": false,
     "start_time": "2024-06-02T22:23:20.827779",
     "status": "completed"
    },
    "tags": []
   },
   "source": [
    "### Plotting"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 9,
   "id": "7e737614",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2024-06-02T22:23:20.872962Z",
     "iopub.status.busy": "2024-06-02T22:23:20.871259Z",
     "iopub.status.idle": "2024-06-02T22:23:20.890317Z",
     "shell.execute_reply": "2024-06-02T22:23:20.888412Z"
    },
    "papermill": {
     "duration": 0.038509,
     "end_time": "2024-06-02T22:23:20.893696",
     "exception": false,
     "start_time": "2024-06-02T22:23:20.855187",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [],
   "source": [
    "theme_set(theme_classic())"
   ]
  },
  {
   "cell_type": "markdown",
   "id": "494154c5",
   "metadata": {
    "papermill": {
     "duration": 0.013708,
     "end_time": "2024-06-02T22:23:20.920941",
     "exception": false,
     "start_time": "2024-06-02T22:23:20.907233",
     "status": "completed"
    },
    "tags": []
   },
   "source": [
    "Let's see what time and what weekday people order more often. Using this we can build more efficiently personal schedule."
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 10,
   "id": "a40b0172",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2024-06-02T22:23:20.952257Z",
     "iopub.status.busy": "2024-06-02T22:23:20.950603Z",
     "iopub.status.idle": "2024-06-02T22:23:21.091217Z",
     "shell.execute_reply": "2024-06-02T22:23:21.089262Z"
    },
    "papermill": {
     "duration": 0.159958,
     "end_time": "2024-06-02T22:23:21.094529",
     "exception": false,
     "start_time": "2024-06-02T22:23:20.934571",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [],
   "source": [
    "weekday_order <- c(\"Monday\", \"Tuesday\", \"Wednesday\", \"Thursday\", \"Friday\", \"Saturday\", \"Sunday\")\n",
    "orders_wk <- orders_history %>% \n",
    "  mutate(weekday = factor(strftime(date, \"%A\"), levels = weekday_order)) %>% \n",
    "  distinct(ticket_number, .keep_all = TRUE)"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 11,
   "id": "612a9dc9",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2024-06-02T22:23:21.125634Z",
     "iopub.status.busy": "2024-06-02T22:23:21.123948Z",
     "iopub.status.idle": "2024-06-02T22:23:21.908020Z",
     "shell.execute_reply": "2024-06-02T22:23:21.895040Z"
    },
    "papermill": {
     "duration": 0.803779,
     "end_time": "2024-06-02T22:23:21.911804",
     "exception": false,
     "start_time": "2024-06-02T22:23:21.108025",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [
    {
     "data": {
      "image/png": "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"
     },
     "metadata": {
      "image/png": {
       "height": 420,
       "width": 420
      }
     },
     "output_type": "display_data"
    }
   ],
   "source": [
    "orders_wk %>% \n",
    "  ggplot(aes(x = time)) +\n",
    "  geom_histogram(binwidth = 3600, fill = \"skyblue\", color = \"black\") +\n",
    "  scale_x_time(labels = time_format(\"%H:%M\"), breaks = breaks_width(\"1 hour\")) +\n",
    "  labs(title = \"Most orders before 13:00\",\n",
    "       x = \"Time of Day\",\n",
    "       y = \"Count of Orders\") "
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 12,
   "id": "e0fcc0cf",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2024-06-02T22:23:21.947215Z",
     "iopub.status.busy": "2024-06-02T22:23:21.945412Z",
     "iopub.status.idle": "2024-06-02T22:23:22.537611Z",
     "shell.execute_reply": "2024-06-02T22:23:22.534350Z"
    },
    "papermill": {
     "duration": 0.615113,
     "end_time": "2024-06-02T22:23:22.541729",
     "exception": false,
     "start_time": "2024-06-02T22:23:21.926616",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [
    {
     "data": {
      "image/png": "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\nOO2xX25lZceUzH6rXX5OCCG/2Wb7HHjIrtttXj8rkdega5fC3DTCLsWfe9phl0wmexXVCyFk\nZTeY8nOJli8cn5eVCCHUa9xzqYNT+amlctiyYVdeMnG7hnkhhD6Pj0/9vlI58RQfkOk+rgAQ\ndr8Ou2QyecA69UMI6251+5Ibl/rLE8lkxSv3Xr7vjps3bVg/J7/h+pt2P+kft/9QsvRHob31\n4FX799yqeePC7Kychk1b77DXn/415IMlD3j9nydusG7jrJy8Tr0eS1ZnJXdXTZ1UlPx46wUn\nbt2xTWFeTuPmbfbu0/eDGcXvnrl5+PVbmj549l+H7Lld8yYNcnLzW7TvesQZV4yZVbLk7azo\nLlZ6jumdUTKZrKxY8NQN5+6yRftG9XPrFTbefIff//O+N5a6lZUeM/Oz5479ww7rNlr0nFCD\ntj0fHjOzd7OCtMIupbF/S9i9dFD7EEKjtucuufGU1g1CCBse9NKyx6/0p5bKYcuGXTKZ/G7o\n30IIuYWbf/lzs670vlI88RQfkOk+rgDWdolkcoWX+0E0yudPn/DDgvad2mZnehIAqD3CDgAg\nEq6KBQCIhLADAIiEsAMAiISwAwCIhLADAIiEsAMAiISwAwCIhLADAIiEsAMAiISwAwCIhLAD\nAIiEsAMAiMTaGHY333zznnvueeqpp2Z6EACAVSkn0wNkwBdffDFs2LA5c+ZkehAAgFVpbXzG\nDgAgSsIOACASwg4AIBLCDgAgEsIOACASwg4AIBLCDgAgEsIOACASwg4AIBLCDgAgEsIOACAS\nwg4AIBLCDgAgEsIOACASwg4AIBLCDgAgEsIOACASwg4AIBLCDgAgEsIOACASwg4AIBLCDgAg\nEsIOACASwg4AIBLCDgAgEsIOACASwg4AIBLCDgAgEsIOACASOZkeAACI36BBg0aMGJHpKequ\n7t279+vX77ffjrADAGrdiBEjhgwZkukp4ifsAIDVpGGzFm27bJ3pKeqWiZ+Mnjtt8qq6NWEH\nAKwmbbts3efaezM9Rd1yf9+jP3t16Kq6NRdPAABEQtgBAERC2AEARELYAQBEQtgBAERC2AEA\nRELYAQBEQtgBAERC2AEARELYAQBEQtgBAERC2AEARELYAQBEQtgBAERC2AEARELYAQBEQtgB\nAERC2AEARELYAQBEQtgBAERC2AEARELYAQBEQtgBAERC2AEARELYAQBEQtgBAERC2AEARELY\nAQBEQtgBAERC2AEARELYAQBEQtgBAERC2AEARELYAQBEQtgBAERC2AEARELYAQBEQtgBAERC\n2AEARELYAQBEQtgBAERC2AEARELYAQBEQtgBAERC2AEARELYAQBEQtgBAERC2AEARELYAQBE\nQtgBAERC2AEARELYAQBEQtgBAERC2AEARELYAQBEQtgBAERC2AEARELYAQBEQtgBAERC2AEA\nRELYAQBEQtgBAERC2AEARELYAQBEQtgBAERC2AEARELYAQBEQtgBAERC2AEARELYAQBEQtgB\nAERC2AEARELYAQBEQtgBAERC2AEARELYAQBEQtgBAERC2AEARELYAQBEQtgBAERC2AEARELY\nAQBEQtgBAERC2AEARELYAQBEQtgBAERC2AEARELYAQBEQtgBAERC2AEARELYAQBEQtgBAERC\n2AEARELYAQBEQtgBAERC2AEARELYAQBEQtgBAERC2AEARELYAQBEQtgBAERC2AEARELYAQBE\nQtgBAERC2AEARELYAQBEQtgBAERC2AEARELYAQBEQtgBAERC2AEARELYAQBEIifTAwDAmmTQ\noEEjRozI9BR1V/fu3fv165fpKdZewg4AamDEiBFDhgzJ9BSwfMIOAGqsYbMWbbtsnekp6paJ\nn4yeO21ypqdY2wk7AKixtl227nPtvZmeom65v+/Rn706NNNTrO1cPAEAEAlhBwAQCWEHABAJ\nYQcAEAlhBwAQCWEHABAJYQcAEAlhBwAQCWEHABAJYQcAEAlhBwAQCWEHABAJYQcAEAlhBwAQ\nCWEHABAJYQcAEAlhBwAQCWEHABAJYQcAEAlhBwAQCWEHABAJYQcAEAlhBwAQCWEHABAJYQcA\nEImc1XM3yfKZT995+4tvfzS9OKtV24779znpd1u2DCGEUPnaI7c898b7E+dmb7r59secfuyG\n9bN//qYV7arpdgCAtcJqesbupYHnPPDaT3845vRBl/XbbaOSWwac8szEeSGE8U9eeN2j7/Q4\n6MSLzzyqYNyw/mffmfz5W1a0q6bbAQDWEqvjGbuKkom3jZ7Wa+A1B3RuEkLouEmXH9877Jnb\nPj/g8q6DHx3boc/g3ntsGELoMCgccvTVD//Y54hWhSFZuvxdLXNrtr1V4Wo4QQCAumB1PGNX\nUfzNBhtuuE/7hj9vSGzZuF7p7Hkls9/4rrhi791aV22t16RntwZ5I1+fHEJY0a6abl8NZwcA\n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\nAKTtN4VdZdnU6y76MLfBli1zfWwKAECGpfoeux49eiyzrfLHrz7+dnrxNhfevGpnAgAgDamG\n3fJkte2y2x93P/Kq/tuvsnEAAEhXqmH3zjvv1OocAAD8RjV7xm7BDx8+8czLn42ftKAip1X7\nznv9sffWbRvU0mQAANRIDcLuyX/86c9XPFZS+csfmeh/5kmH9H/w0UsProXBAAComVSvZp3w\n+J97X/bour2Oe/Tld3+YMn3m1Ekjhz9x/C4tHrusd5+nvqnNCQEASEmqz9hdc+azDdoc8/mw\nOwuyElVbttn14K177V25QcvHTrs2HHRTrU0IAEBKUn3G7pGpCzr95YzFVVclkVVwxqkbL5z6\ncC0MBgBAzaQadg2ysoonFy+7vXhycSLb9RMAAJmXatid2bHx1/edPGrmr/4mbOns90/995eN\nO5xRC4MBAFAzqb7H7tgnLr2482k7tut23KnH7ti1Q35YOO6Tt++5+e4vF+Td+PixtToiAACp\nSDXsijY++bOXc448+YLbBp53288bm26887/+df9JmxTV0nAAAKSuBp9jt96uf3lt7Inffz56\nzLhJJaFe6/abbbVp21RfygUAoJbV9G/FJtbbZJv1NqmVUQAA+C1q8IzbtNFDTjx4z2OGfFv1\n5bDfbdlj3z6PvTe1dgYDAKBmUg272V/d0an7wXc/Nzo3f9G3NN2q47fDHzl8x463jp1Za+MB\nAJCqVMPurgMvmF9/yze+++HO37et2rLVlY+N/+7t7QuKLzrkjlobDwCAVKUadtd9PbvDUTfv\n2LL+khvzm29740kbz/rqhloYDACAmkk17CqSybzGectuzy7IDqFylY4EAEA6Ug27U9s1+uL2\nCyeWVCy5sbL0xwE3f95wvb/WwmAAANRMqh93ctKTF12xxTmdN9mt79nH7ti1Q0FW2YTP3r13\n8D+HTS8fMPTUWh0RAIBUpBp2TTc/a8xz2Yf8tf+A099YvDG/6SaXPPz4Rds2r53ZAACogRp8\nQHG7vU8f+e1Jn454/YPPv11QkdOqfeddem3TKDtRe8MBAJC6Gv7liUTe5j323LxH7cwCAMBv\n4G+9AgBEQtgBAESihi/FArVs0KBBI0aMyPQUdVT37t379euX6SkA6i5hB3XLiBEjhgwZkukp\nAFgjCTuoixo2a9G2y9aZnqIOmfjJ6LnTJmd6CoC6rkZhV/nj+HGt2ncMIdW1ZGsAACAASURB\n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\nRELYAQBEQtgBAERC2AEARELYAQBEQtgBAERC2AEARELYAQBEQtgBAERC2AEARELYAQBEQtgB\nAERC2AEARELYAQBEQtgBAERC2AEARELYAQBEQtgBAERC2AEARELYAQBEQtgBAERC2AEARELY\nAQBEQtgBAERC2AEARELYAQBEQtgBAERC2AEARELYAQBEQtgBAERC2AEARELYAQBEQtgBAERC\n2AEARELYAQBEQtgBAERC2AEARELYAQBEQtgBAERC2AEARELYAQBEQtgBAERC2AEARELYAQBE\nQtgBAERC2AEARELYAQBEQtgBAERC2AEARELYAQBEQtgBAERC2AEARELYAQBEQtgBAERC2AEA\nRELYAQBEQtgBAERC2AEARELYAQBEQtgBAERC2AEARELYAQBEQtgBAERC2AEARELYAQBEQtgB\nAERC2AEARELYAQBEQtgBAERC2AEARELYAQBEQtgBAERC2AEARELYAQBEQtgBAERC2AEARELY\nAQBEQtgBAERC2AEARELYAQBEQtgBAERC2AEARELYAQBEQtgBAERC2AEARELYAQBEQtgBAERC\n2AEARELYAQBEQtgBAERC2AEARELYAQBEQtgBAERC2AEARELYAQBEQtgBAERC2AEARELYAQBE\nQtgBAERC2AEARELYAQBEQtgBAERC2AEARELYAQBEQtgBAERC2AEARELYAQBEQtgBAERC2AEA\nRELYAQBEQtgBAERC2AEARELYAQBEQtgBAERC2AEARELYAQBEQtgBAERC2AEARELYAQBEQtgB\nAERC2AEARELYAQBEQtgBAERC2AEARELYAQBEQtgBAERC2AEARELYAQBEQtgBAERC2AEARELY\nAQBEQtgBAERC2AEARELYAQBEQtgBAERC2AEARELYAQBEQtgBAERC2AEARELYAQBEQtgBAERC\n2AEARELYAQBEQtgBAERC2AEARELYAQBEQtgBAERC2AEARELYAQBEQtgBAERC2AEARELYAQBE\nQtgBAERC2AEARELYAQBEQtgBAERC2AEARELYAQBEQtgBAERC2AEARELYAQBEQtgBAERC2AEA\nRELYAQBEQtgBAERC2AEARELYAQBEQtgBAERC2AEARELYAQBEQtgBAERC2AEARELYAQBEQtgB\nAERC2AEARELYAQBEQtgBAERC2AEARELYAQBEQtgBAERC2AEARELYAQBEQtgBAERC2AEARELY\n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\ntW7Cro5JhvDzfy98ed+5//6k7Q3/vmK3HXtuPO3Nx15+5b2pRVWPxRBCdv0mnbfp2earVx4b\nVnnwvptnbuI6YIlFC9YtddYtPdYtPdYtPdYtPWvxurkqtg4pm//pOceeNeKnBVVfPvzfiZ3+\nckKb/Oyy+Z/f9L+FF155yrw37jjrxhem/fjxl/PLqo7Z4vju875/dEHl2vt6+lKLFqxbaqxb\neqxbeqxbeqxbetbydRN2dUhuQaftN1541en9qh6O7RvmFn8zL5ksvv3cSzufOnC7zr/rf9iG\nE4bdfvxJF734wYwQQgjJ/97/Xl6jretnRfCugDQttWjBuqXGuqXHuqXHuqXHuqVnbV+3JHVK\nZcljA/964CGnvvPj/OIZY0sqk98+c8GRZz9dtfOzf5185divP/56+uLDv3/72THTijM0a52x\nxKIlk0nrlirrlh7rlh7rlh7rlp61eN08Y1fHJPL2Ov6Cni1mXHV6vw9K1s9LhI+fn1C06aYh\nhAWTRg1+bdaf2rXrslHTxYe36bHfZuvUy9y4dcMSizbipwX1mmxi3VJi3dJj3dJj3dJj3dKz\nFq+biyfqkGTFnIdvuHjgrc9WFjVdMP3bN18auUHPXTbM/eTRxx9979OP77/3yc37XPGHzZtn\nesy6ZbmLtl6D3NyS961bNaxbeqxbeqxbeqxbetb2dcv0U4b84oObT+595CXjZpckk8nSOd/d\nduHxBx5y6js/zvvwv4/fdstdr4yelOkB66IVLNr8ZLLSulXDuqXHuqWoePrYhZWVi7+0bumx\nbulZy9dN2NUhfz/soH4vf7/4y8rKhTccf9jitwiwXBYtPdYtPdYtNZXXHn3IiQOHLv7autVU\nZdnCpHVL11q+bt5jV4fkJhIl00sWf5lI5B96zEY5DcuuOr3fN8UVGRysLrNo6bFu6bFuqUmc\n9M+zDu69Q7JiZnEyGaxbzT3S/+T7xsy0bulZy9dN2NUhR+zS6tsnb5qwxMNuwQ8L1+l2xpVn\nnNIuPzuDg9U9ye8/H/XOqI9LkkmLVhPWLT3WrcYKWvb4XcfG/zeg72mXP1Js3WoiWTGnvGza\n4xMa7d2psXVLz1q+bi6eyKRkxeynb7nq6uvvfPWTyRtvv2WHrbtPGP7Y/c98sE67di0a5Yx/\n9/kr7npj11OP2rVbm0xPWockK2bfd+XZ19479M3XX5nSerf9DtjNoqXCuqXHuqUnWV6cyMpp\n26XNG/fe8cznlYefeuxE65aaly/9282f1M8q7nbEfu2bddvO4y0VfpkuKZFMrvEfsrymSlb8\n6+yjRyS6HNirw6f/fWJM6WZX3nh+u9xZD1838PG3xlUmk1k5Rfud0O/4fTpnetC65bWr/nLb\n+I79Lz5l/TCrcavWFcWz5pQWD73tKotWPeuWHuuWnof7HVd21LVHdW5SPHXUeaddOb9z7xv6\n7fH09Vdat5UqmflR/1MuG1fa/OaHbm6Tl11ZNs0vhZXwy3QpmX6T31qqsnz2/GnPHXTY32eV\nVyaTyYrSydedfsShx186bn5ZMpksnjHxozFfTplTmukx65yK0qkH7b//kKkLkslk+YLvH775\n4oP33/+APx754PvTLFo1rFt6rFuKFk4ZdcGZV39fUp5MJivLZ5eVTj3wkDOmlFb8vHfkGYcd\ndMKlDy2srLRuK1JZNuOea++ZUVaZTCaLZ3zY9/CD+/z9jtnli64stm4r4pfpsrwUmxkvX/q3\nG96fV1G2yxH7dQghJLILt9uj56TXHrzn2c+33mPH5o2KWjRfp7Be/G8FqKlk5fwnHn+2sl7T\n5LfvXH3pdd8Vdj39rL+1nzPiiRcX/ulPvSzaili3mqp6JdG6paJ46ujzTxs4Y/3teu/SNSeR\nWPKVxKoDcgpb79Jro6rXZPfea4c261q35ags/fG5e2578K1pu+62TYPClr122/jdR+5+4v25\nu++6Zb2sRE79Rh5vy+WX6bJcPJEZvc44o/CzMQumPvlTaWXVlqzcdU+/5roehZ+ff/qVM8u9\nPr58WbnNLz16t8+fvPP+l77c58yrbrn4b1tv3GHzNoXZeY0yPVqdZt1qquqaROu2UlVVN3ez\ng26+8Ij8rEQIodcZZ+S+98DMyY/9UPrLW9fzm2/zz5vOLxzzxB3vT8/csHVadn77C266suPM\n104/77aZ5cl6Tbpd8a+Lmn/7f6ddeNecCr8RlpYsn3nv4Htnlif9Ml2W99itTskP/vv0iM/H\nZTXdaIfdf9+p/lf9T7lsatvf3TTwhEbZi/7qcGXZlCdemHToH7fI7KB1S7L07ReffH3056W5\nRT32OnSvrdqEkAwhUVlSmVUva+bnw8684OZdL/vPMZ2bZHrQOsa6pSVZMaeisvTQP19++4OD\nm+dW/aevdVu+ZasuhFCRDOWzPup/ymVT1vvdzVf+8n9uIYSyOZNzG7XI0LB1VLJidkVW45yf\n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\nrkJggg=="
     },
     "metadata": {
      "image/png": {
       "height": 420,
       "width": 420
      }
     },
     "output_type": "display_data"
    }
   ],
   "source": [
    "orders_wk %>% \n",
    "  ggplot(aes(weekday)) + \n",
    "  geom_bar(fill = \"skyblue\", color = \"black\") + \n",
    "  labs(title = \"Most orders occur on weekends\",\n",
    "       x = NULL,\n",
    "       y = \"Orders count\") + theme_classic() +\n",
    "  theme(axis.text.x = element_text(angle = 45, hjust = 1))"
   ]
  },
  {
   "cell_type": "markdown",
   "id": "0c50d2ff",
   "metadata": {
    "papermill": {
     "duration": 0.020408,
     "end_time": "2024-06-02T22:23:22.584585",
     "exception": false,
     "start_time": "2024-06-02T22:23:22.564177",
     "status": "completed"
    },
    "tags": []
   },
   "source": [
    "Not surprising most orders before lunch. But interesting why in Wednesday so low order count"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 13,
   "id": "881798c9",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2024-06-02T22:23:22.619047Z",
     "iopub.status.busy": "2024-06-02T22:23:22.617338Z",
     "iopub.status.idle": "2024-06-02T22:23:23.517359Z",
     "shell.execute_reply": "2024-06-02T22:23:23.515051Z"
    },
    "papermill": {
     "duration": 0.920478,
     "end_time": "2024-06-02T22:23:23.520235",
     "exception": false,
     "start_time": "2024-06-02T22:23:22.599757",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [
    {
     "data": {
      "image/png": "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\n9Bgz1dol2Lr+/fubY1Ni8Vudoy3+yr7eHmOmmmPls/htAYu/wvHVWeF29lWsk5uniGRqtAGu\n1y6tnKEpVfvdeBXe3t7NmzfX3/6///u/0tJSI48WExNTqWc/fvx4Zmamv79/kyZNGF/98SJy\ndv+2qKgo0x/f09MzODjYxAe3tddbhX8fqfwqNdPD2to/jr2PFwdb/FLJ1ysij3YzaXdIFbD4\nrTteWPwVqebit7Ng5+LZUmT7kQJNgKubvuVYQYlPlE/ZgPbt269cuVJ/29/fPz8/38ijcREd\nOCwWPxwWix/KZmc/Kebu2y3Y1Xnjrkv6u5rc/Xtzitt2C7BuVQAAALbAzoKdqFziBzU7/uHM\nLfuPnUs98MGMJK/gXnFBXOsEAADA3r6KFZHIIXPGFy38LGnG5UJVROsus+NHc3ViAAAAscdg\nJyrnXsPiew2zdhkAAAA2xt6+igUAAIABBDsAAACFsMOvYgGY4Jdfftm5c6e1qwDMpVWrVn36\n9Cm368yZM6tWrbJwPYDF+Pr6jhkzxlCvkoNdly5dcnNzQ0NDrV0IYAWbN29+5ZVX3Nzc3Nzc\ntFptbm6utSuqCnd3d1dX19LS0ry8PGvXUhUeHh4uLi4lJSXGr6lpszw9PdVqtUajKSgosHYt\ntxo5cqShYJeamvrCCy84Ozt7eXmJSG5urlartWx1NUCtVnt6eopITk6Ozq5+/FPPxcXFw8ND\np9Pl5ORYu5aqcHV1dXd3t803z/DwcAcNdub4hU3AXnh4ePhdV1JScubMGWtXVBV16tTx8fEp\nKio6e/astWupinr16nl7excUFKSnp1u7lqoICAjw9PTMy8u7cOGCtWu5lT70lEutVvv5+bm7\nuwcFBYlIWlqaRqOxYGk1w8vLq0GDBiJy+vRpewym3t7e9erV0+l0p06dsnYtVeHj41OnTp3S\n0tK//vrL2rXcysfHx0ivyh4/BwAw0QcffLBkyZLAwMBvvvnG2rVURVJS0meffda0adNPP/3U\n2rVURWJi4oYNGzp06LB48WJr11IVkydP/uWXX3r37j1v3jxr11Jpv/322+jRo0Vk/fr1+oRn\nX7Zv3x4fHy8i27Ztq1WrlrXLqbT169fPmjXL2dk5JSXF2rVUxX//IgOfawAAIABJREFU+99F\nixb5+/tv2rTJ2rVUDidPAAAAKATBDgAAQCH4KhZQsnPnzv3999+urq5t2rSxdi1VcebMmfPn\nz3t6ekZHR1u7lqpITU3NyMioXbt2s2bNrF1LVRw7duzKlSv+/v6RkZHWrqXScnJyDh8+LCKt\nW7d2c3OzdjmVlpWVdfz4cRFp166ds7OztcuptEuXLumPruvQoYO1a6mK9PT0tLQ0tVrdtm1b\na9dSOQQ7AAAAheCrWAAAAIUg2AFA5RRdzS7Q8l0HHBGL3/Yp+Tp2InLu3LnCwkJrVwGYTrv3\nhy927D98Ps85PDK672MPB7vd+PR19v82f/fL76l/XaxVP7xH7GMdI2uLSP369W+6FIJ22+rF\n3+zYn5bj3Dy64/CJI8I8nE3o+kcBBoaZOP2aj8cNc5+15NF6HiY8sinPbpnpxuu/pjArZfTI\nV//13qdjArzsqH5dSdY3Hy35bvfBSwXOjSKiB48ZHxNig/UbHHZq55efbtx16OhZn4bNB46a\n1DParzLTLbr4pZx/f8sUYL76rzG6+G2l/qouflupvwboFK1r167m/ecDapRP5N0PPXh/k9AA\n//rB7Xv0ub9bS9X1Lvf6LR566MGW4SH+fv7hLf/10IO9/NVOIrJixYqyBX/yyxf79R/6xY+7\n/ty7Y/7oIY+NfU9rQtfNDA0zcbpOp9PptMd//rBfv34rL+SZ8sgmjrHAdOP1X+srLXhz9JC+\nffsuSc+9vdeW6//xlZEDhsR/t+u3owf2Lp0xvP/gZy4Ul9pa/YaGXdr7Yb9+sYu//vHgkT+/\nXjL14QHDD+ZpTJ9uwcWvK/ff3zIFmK/+ax1GF79t1F/1xW8b9dcMhe+x01Or1fywGOyAShXZ\n1L/wUmqp2tO3llxJOx/YtHHHZoUXi0tFJLRZWHHmmTxx8fXzlbz0s5frB/q4Zl6+aYe0rjhp\nzeHIuKRBPcNEJHKBDB72+qr0uKGBXsa6bmZoWICLSdNFzv+8cPqynRezi259aaYUUM36q//y\njdR/3e8rpu2r3VXObyynz4br1+mKlu7PaPHCq/fH1BeRiMiXvn0kfsXfuVPDattQ/YaHLU7a\nGNp39rj+USLSoun80+mJu1NzWtyy066aq7fai9/gv79ltj7z1X+dscVvA/VXa/HbQP01yczB\n0cr0e+zCwsKsXQhQscKsH/v27ftjVmFZy/THBk5edVKn0xVd3dW3b9/vMgvKusLCwvSb8LK3\nxvTt23fNpXwj0410XUmdrZ9uZJiR6bcoupJ2/Pjxo4d+6du3780fmk0poJr1V226ifXrZR//\n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"
     },
     "metadata": {
      "image/png": {
       "height": 420,
       "width": 420
      }
     },
     "output_type": "display_data"
    }
   ],
   "source": [
    "orders_wk %>% \n",
    "  ggplot(aes(x = time)) + \n",
    "  geom_histogram(binwidth = 3600, fill = \"skyblue\", color = \"black\") + \n",
    "  facet_wrap(weekday~.)"
   ]
  },
  {
   "cell_type": "markdown",
   "id": "f9295863",
   "metadata": {
    "papermill": {
     "duration": 0.016136,
     "end_time": "2024-06-02T22:23:23.553372",
     "exception": false,
     "start_time": "2024-06-02T22:23:23.537236",
     "status": "completed"
    },
    "tags": []
   },
   "source": [
    "Despite the short day om Sunday most orders fall on this day.\n",
    "\n",
    "Let's see if there is any seasonality"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 14,
   "id": "3cdee71b",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2024-06-02T22:23:23.590584Z",
     "iopub.status.busy": "2024-06-02T22:23:23.588851Z",
     "iopub.status.idle": "2024-06-02T22:23:24.252462Z",
     "shell.execute_reply": "2024-06-02T22:23:24.250552Z"
    },
    "papermill": {
     "duration": 0.68565,
     "end_time": "2024-06-02T22:23:24.255360",
     "exception": false,
     "start_time": "2024-06-02T22:23:23.569710",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [
    {
     "data": {
      "image/png": "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"
     },
     "metadata": {
      "image/png": {
       "height": 420,
       "width": 420
      }
     },
     "output_type": "display_data"
    }
   ],
   "source": [
    "orders_history %>% \n",
    "  distinct(ticket_number, .keep_all = TRUE) %>% \n",
    "  ggplot(aes(month)) +\n",
    "  geom_histogram(binwidth = 0.5, fill = \"skyblue\", color = \"black\") + \n",
    "  facet_wrap(.~year, nrow = 2, ncol = 1) + \n",
    "  scale_x_continuous(breaks = 1:12, labels = month.name[1:12]) + \n",
    "  theme(axis.text.x = element_text(angle = 45, hjust = 1)) + \n",
    "  labs(title = \"Sales pick falls within two summer month\", \n",
    "       subtitle = \"There is a decrease in demand in winter\")"
   ]
  },
  {
   "cell_type": "markdown",
   "id": "248d962a",
   "metadata": {
    "papermill": {
     "duration": 0.016949,
     "end_time": "2024-06-02T22:23:24.289260",
     "exception": false,
     "start_time": "2024-06-02T22:23:24.272311",
     "status": "completed"
    },
    "tags": []
   },
   "source": [
    "### ABC analysis"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 15,
   "id": "dd6cf9d3",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2024-06-02T22:23:24.329344Z",
     "iopub.status.busy": "2024-06-02T22:23:24.327530Z",
     "iopub.status.idle": "2024-06-02T22:23:24.383467Z",
     "shell.execute_reply": "2024-06-02T22:23:24.381402Z"
    },
    "papermill": {
     "duration": 0.07989,
     "end_time": "2024-06-02T22:23:24.386036",
     "exception": false,
     "start_time": "2024-06-02T22:23:24.306146",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [
    {
     "data": {
      "text/html": [
       "<table class=\"dataframe\">\n",
       "<caption>A tibble: 14 × 2</caption>\n",
       "<thead>\n",
       "\t<tr><th scope=col>article</th><th scope=col>income</th></tr>\n",
       "\t<tr><th scope=col>&lt;chr&gt;</th><th scope=col>&lt;dbl&gt;</th></tr>\n",
       "</thead>\n",
       "<tbody>\n",
       "\t<tr><td>tarte fruits 4p   </td><td>3630</td></tr>\n",
       "\t<tr><td>tarte fruits 6p   </td><td>3608</td></tr>\n",
       "\t<tr><td>tarte fraise 6p   </td><td>2418</td></tr>\n",
       "\t<tr><td>tarte fraise 4per </td><td>2144</td></tr>\n",
       "\t<tr><td>gal frangipane 4p </td><td>1712</td></tr>\n",
       "\t<tr><td>gal frangipane 6p </td><td>1536</td></tr>\n",
       "\t<tr><td>royal 6p          </td><td>1269</td></tr>\n",
       "\t<tr><td>royal 4p          </td><td> 984</td></tr>\n",
       "\t<tr><td>gal pomme 4p      </td><td> 792</td></tr>\n",
       "\t<tr><td>gal pomme 6p      </td><td> 744</td></tr>\n",
       "\t<tr><td>gal poire choco 4p</td><td> 192</td></tr>\n",
       "\t<tr><td>gal poire choco 6p</td><td> 180</td></tr>\n",
       "\t<tr><td>buche 6pers       </td><td> 168</td></tr>\n",
       "\t<tr><td>buche 4pers       </td><td> 154</td></tr>\n",
       "</tbody>\n",
       "</table>\n"
      ],
      "text/latex": [
       "A tibble: 14 × 2\n",
       "\\begin{tabular}{ll}\n",
       " article & income\\\\\n",
       " <chr> & <dbl>\\\\\n",
       "\\hline\n",
       "\t tarte fruits 4p    & 3630\\\\\n",
       "\t tarte fruits 6p    & 3608\\\\\n",
       "\t tarte fraise 6p    & 2418\\\\\n",
       "\t tarte fraise 4per  & 2144\\\\\n",
       "\t gal frangipane 4p  & 1712\\\\\n",
       "\t gal frangipane 6p  & 1536\\\\\n",
       "\t royal 6p           & 1269\\\\\n",
       "\t royal 4p           &  984\\\\\n",
       "\t gal pomme 4p       &  792\\\\\n",
       "\t gal pomme 6p       &  744\\\\\n",
       "\t gal poire choco 4p &  192\\\\\n",
       "\t gal poire choco 6p &  180\\\\\n",
       "\t buche 6pers        &  168\\\\\n",
       "\t buche 4pers        &  154\\\\\n",
       "\\end{tabular}\n"
      ],
      "text/markdown": [
       "\n",
       "A tibble: 14 × 2\n",
       "\n",
       "| article &lt;chr&gt; | income &lt;dbl&gt; |\n",
       "|---|---|\n",
       "| tarte fruits 4p    | 3630 |\n",
       "| tarte fruits 6p    | 3608 |\n",
       "| tarte fraise 6p    | 2418 |\n",
       "| tarte fraise 4per  | 2144 |\n",
       "| gal frangipane 4p  | 1712 |\n",
       "| gal frangipane 6p  | 1536 |\n",
       "| royal 6p           | 1269 |\n",
       "| royal 4p           |  984 |\n",
       "| gal pomme 4p       |  792 |\n",
       "| gal pomme 6p       |  744 |\n",
       "| gal poire choco 4p |  192 |\n",
       "| gal poire choco 6p |  180 |\n",
       "| buche 6pers        |  168 |\n",
       "| buche 4pers        |  154 |\n",
       "\n"
      ],
      "text/plain": [
       "   article            income\n",
       "1  tarte fruits 4p    3630  \n",
       "2  tarte fruits 6p    3608  \n",
       "3  tarte fraise 6p    2418  \n",
       "4  tarte fraise 4per  2144  \n",
       "5  gal frangipane 4p  1712  \n",
       "6  gal frangipane 6p  1536  \n",
       "7  royal 6p           1269  \n",
       "8  royal 4p            984  \n",
       "9  gal pomme 4p        792  \n",
       "10 gal pomme 6p        744  \n",
       "11 gal poire choco 4p  192  \n",
       "12 gal poire choco 6p  180  \n",
       "13 buche 6pers         168  \n",
       "14 buche 4pers         154  "
      ]
     },
     "metadata": {},
     "output_type": "display_data"
    }
   ],
   "source": [
    "total_revenue <- sum(orders_history$amount)\n",
    "\n",
    "revenue_by_article <- orders_history %>% \n",
    "  group_by(article) %>% \n",
    "  summarize(income = sum(amount)) %>% \n",
    "  arrange(desc(income))\n",
    "\n",
    "revenue_by_article %>% \n",
    "  filter(str_detect(article, \"[46][p]\"))"
   ]
  },
  {
   "cell_type": "markdown",
   "id": "157a4485",
   "metadata": {
    "papermill": {
     "duration": 0.017881,
     "end_time": "2024-06-02T22:23:24.422008",
     "exception": false,
     "start_time": "2024-06-02T22:23:24.404127",
     "status": "completed"
    },
    "tags": []
   },
   "source": [
    "14 positions that echoes true positions in menu. We should fix it. Income column should be correct because in orders table used unit price.\n"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 16,
   "id": "150a6ceb",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2024-06-02T22:23:24.462152Z",
     "iopub.status.busy": "2024-06-02T22:23:24.460236Z",
     "iopub.status.idle": "2024-06-02T22:23:24.493489Z",
     "shell.execute_reply": "2024-06-02T22:23:24.491339Z"
    },
    "papermill": {
     "duration": 0.055843,
     "end_time": "2024-06-02T22:23:24.496350",
     "exception": false,
     "start_time": "2024-06-02T22:23:24.440507",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [],
   "source": [
    "fixed_revenue_by_article <- revenue_by_article %>% \n",
    "  mutate(fixed_article = str_remove(article, '\\\\s*\\\\d+[a-zA-Z]*$')) %>% \n",
    "  group_by(fixed_article) %>% \n",
    "  summarize(income = sum(income)) %>% \n",
    "  arrange(desc(income))"
   ]
  },
  {
   "cell_type": "markdown",
   "id": "015f2605",
   "metadata": {
    "papermill": {
     "duration": 0.017905,
     "end_time": "2024-06-02T22:23:24.531791",
     "exception": false,
     "start_time": "2024-06-02T22:23:24.513886",
     "status": "completed"
    },
    "tags": []
   },
   "source": [
    "Define category find function\n"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 17,
   "id": "f7b85781",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2024-06-02T22:23:24.570625Z",
     "iopub.status.busy": "2024-06-02T22:23:24.568622Z",
     "iopub.status.idle": "2024-06-02T22:23:24.584536Z",
     "shell.execute_reply": "2024-06-02T22:23:24.582316Z"
    },
    "papermill": {
     "duration": 0.038126,
     "end_time": "2024-06-02T22:23:24.587409",
     "exception": false,
     "start_time": "2024-06-02T22:23:24.549283",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [],
   "source": [
    "set_category <- function(cumulative_procent) {\n",
    "  category = case_when(\n",
    "    between(cumulative_procent, 0, 80) ~ \"A\",\n",
    "    between(cumulative_procent, 80, 95) ~ \"B\",\n",
    "    .default = \"C\"\n",
    "  )\n",
    "  return(category)\n",
    "}"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 18,
   "id": "53d68d5e",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2024-06-02T22:23:24.625838Z",
     "iopub.status.busy": "2024-06-02T22:23:24.623917Z",
     "iopub.status.idle": "2024-06-02T22:23:24.662250Z",
     "shell.execute_reply": "2024-06-02T22:23:24.660229Z"
    },
    "papermill": {
     "duration": 0.060442,
     "end_time": "2024-06-02T22:23:24.665039",
     "exception": false,
     "start_time": "2024-06-02T22:23:24.604597",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [
    {
     "data": {
      "text/html": [
       "<table class=\"dataframe\">\n",
       "<caption>A tibble: 3 × 2</caption>\n",
       "<thead>\n",
       "\t<tr><th scope=col>category</th><th scope=col>n</th></tr>\n",
       "\t<tr><th scope=col>&lt;chr&gt;</th><th scope=col>&lt;int&gt;</th></tr>\n",
       "</thead>\n",
       "<tbody>\n",
       "\t<tr><td>A</td><td>23</td></tr>\n",
       "\t<tr><td>B</td><td>29</td></tr>\n",
       "\t<tr><td>C</td><td>82</td></tr>\n",
       "</tbody>\n",
       "</table>\n"
      ],
      "text/latex": [
       "A tibble: 3 × 2\n",
       "\\begin{tabular}{ll}\n",
       " category & n\\\\\n",
       " <chr> & <int>\\\\\n",
       "\\hline\n",
       "\t A & 23\\\\\n",
       "\t B & 29\\\\\n",
       "\t C & 82\\\\\n",
       "\\end{tabular}\n"
      ],
      "text/markdown": [
       "\n",
       "A tibble: 3 × 2\n",
       "\n",
       "| category &lt;chr&gt; | n &lt;int&gt; |\n",
       "|---|---|\n",
       "| A | 23 |\n",
       "| B | 29 |\n",
       "| C | 82 |\n",
       "\n"
      ],
      "text/plain": [
       "  category n \n",
       "1 A        23\n",
       "2 B        29\n",
       "3 C        82"
      ]
     },
     "metadata": {},
     "output_type": "display_data"
    }
   ],
   "source": [
    "final_shape <- fixed_revenue_by_article %>% \n",
    "  mutate(\n",
    "    prop = income / total_revenue,\n",
    "    cumulative_procent = cumsum(prop) * 100,\n",
    "    category = set_category(cumulative_procent))\n",
    "\n",
    "final_shape %>% \n",
    "  count(category)"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 19,
   "id": "49a007d5",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2024-06-02T22:23:24.704046Z",
     "iopub.status.busy": "2024-06-02T22:23:24.702218Z",
     "iopub.status.idle": "2024-06-02T22:23:24.799237Z",
     "shell.execute_reply": "2024-06-02T22:23:24.795860Z"
    },
    "papermill": {
     "duration": 0.119784,
     "end_time": "2024-06-02T22:23:24.802262",
     "exception": false,
     "start_time": "2024-06-02T22:23:24.682478",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "\u001b[90m# A tibble: 23 × 5\u001b[39m\n",
      "   fixed_article         income    prop cumulative_procent category\n",
      "   \u001b[3m\u001b[90m<chr>\u001b[39m\u001b[23m                  \u001b[3m\u001b[90m<dbl>\u001b[39m\u001b[23m   \u001b[3m\u001b[90m<dbl>\u001b[39m\u001b[23m              \u001b[3m\u001b[90m<dbl>\u001b[39m\u001b[23m \u001b[3m\u001b[90m<chr>\u001b[39m\u001b[23m   \n",
      "\u001b[90m 1\u001b[39m traditional baguette \u001b[4m1\u001b[24m\u001b[4m4\u001b[24m\u001b[4m5\u001b[24m534. 0.259                 25.9 A       \n",
      "\u001b[90m 2\u001b[39m formule sandwich      \u001b[4m3\u001b[24m\u001b[4m5\u001b[24m420. 0.062\u001b[4m9\u001b[24m                32.2 A       \n",
      "\u001b[90m 3\u001b[39m croissant             \u001b[4m3\u001b[24m\u001b[4m3\u001b[24m770. 0.060\u001b[4m0\u001b[24m                38.2 A       \n",
      "\u001b[90m 4\u001b[39m pain au chocolat      \u001b[4m3\u001b[24m\u001b[4m1\u001b[24m262. 0.055\u001b[4m6\u001b[24m                43.7 A       \n",
      "\u001b[90m 5\u001b[39m banette               \u001b[4m2\u001b[24m\u001b[4m4\u001b[24m704. 0.043\u001b[4m9\u001b[24m                48.1 A       \n",
      "\u001b[90m 6\u001b[39m baguette              \u001b[4m2\u001b[24m\u001b[4m0\u001b[24m578. 0.036\u001b[4m6\u001b[24m                51.8 A       \n",
      "\u001b[90m 7\u001b[39m sandwich complet      \u001b[4m1\u001b[24m\u001b[4m3\u001b[24m660. 0.024\u001b[4m3\u001b[24m                54.2 A       \n",
      "\u001b[90m 8\u001b[39m special bread         \u001b[4m1\u001b[24m\u001b[4m3\u001b[24m499. 0.024\u001b[4m0\u001b[24m                56.6 A       \n",
      "\u001b[90m 9\u001b[39m traiteur              \u001b[4m1\u001b[24m\u001b[4m2\u001b[24m368. 0.022\u001b[4m0\u001b[24m                58.8 A       \n",
      "\u001b[90m10\u001b[39m boule                 \u001b[4m1\u001b[24m\u001b[4m1\u001b[24m087. 0.019\u001b[4m7\u001b[24m                60.8 A       \n",
      "\u001b[90m11\u001b[39m grand far breton      \u001b[4m1\u001b[24m\u001b[4m0\u001b[24m786  0.019\u001b[4m2\u001b[24m                62.7 A       \n",
      "\u001b[90m12\u001b[39m tartelette            \u001b[4m1\u001b[24m\u001b[4m0\u001b[24m398. 0.018\u001b[4m5\u001b[24m                64.5 A       \n",
      "\u001b[90m13\u001b[39m cereal baguette        \u001b[4m9\u001b[24m538. 0.017\u001b[4m0\u001b[24m                66.2 A       \n",
      "\u001b[90m14\u001b[39m vik bread              \u001b[4m9\u001b[24m322. 0.016\u001b[4m6\u001b[24m                67.9 A       \n",
      "\u001b[90m15\u001b[39m brioche                \u001b[4m9\u001b[24m274  0.016\u001b[4m5\u001b[24m                69.5 A       \n",
      "\u001b[90m16\u001b[39m gd kouign amann        \u001b[4m8\u001b[24m135  0.014\u001b[4m5\u001b[24m                71.0 A       \n",
      "\u001b[90m17\u001b[39m campagne               \u001b[4m8\u001b[24m111  0.014\u001b[4m4\u001b[24m                72.4 A       \n",
      "\u001b[90m18\u001b[39m eclair                 \u001b[4m7\u001b[24m537. 0.013\u001b[4m4\u001b[24m                73.7 A       \n",
      "\u001b[90m19\u001b[39m tarte fruits           \u001b[4m7\u001b[24m238  0.012\u001b[4m9\u001b[24m                75.0 A       \n",
      "\u001b[90m20\u001b[39m moisson                \u001b[4m6\u001b[24m948. 0.012\u001b[4m3\u001b[24m                76.3 A       \n",
      "\u001b[90m21\u001b[39m sand jb emmental       \u001b[4m6\u001b[24m702. 0.011\u001b[4m9\u001b[24m                77.5 A       \n",
      "\u001b[90m22\u001b[39m complet                \u001b[4m5\u001b[24m817. 0.010\u001b[4m3\u001b[24m                78.5 A       \n",
      "\u001b[90m23\u001b[39m kouign amann           \u001b[4m5\u001b[24m198. 0.009\u001b[4m2\u001b[24m\u001b[4m4\u001b[24m               79.4 A       \n"
     ]
    }
   ],
   "source": [
    "final_shape %>% \n",
    "  filter(category == \"A\") %>% \n",
    "  print(n = 23)"
   ]
  },
  {
   "cell_type": "markdown",
   "id": "445f2de8",
   "metadata": {
    "papermill": {
     "duration": 0.018131,
     "end_time": "2024-06-02T22:23:24.838642",
     "exception": false,
     "start_time": "2024-06-02T22:23:24.820511",
     "status": "completed"
    },
    "tags": []
   },
   "source": [
    "As we can see 25% of income comes from *traditional baguette* And *traditional baguette* is vital for business\n",
    "\n",
    "### Advices\n",
    "\n",
    "1. *Work Schedule Optimization* Tip: Concentrate the majority of staff during the first half of the day when the peak of orders occurs (60-70% of all daily orders). This will enhance productivity and improve service quality.\n",
    "\n",
    "2.  *High season Strategy* Tip: During the summer months, when there is a peak in orders, utilize all available resources.For example bring in students for internships and temporary work.\n",
    "\n",
    "3.  *Low season Strategy* Tip: In the winter months, redirect production capacity to create special offers for restaurants and cafes or open(connect) delivery services and offer personalized orders, such as elaborate cakes and holiday baked goods.\n",
    "\n",
    "4.  *Marketing Strategy* Tip: During the high season (summer), increase the average transaction value by offering additional products and services. Tip: In the low season (winter), focus on increasing the number of orders through discounts and promotions. These strategies will help balance revenue throughout the year.\n",
    "\n",
    "\n",
    "### Conclusions and prospects\n",
    "\n",
    "1.  Assortment Optimization The core of the bakery's sales consists of about 8-12 key items. The rest have a minimal impact on revenue. The best strategy to increase profitability is to retain these key items and eliminate some of the B and C category products. However, additional analysis is needed to determine which items should be removed, taking into account the costs of preparing each item.\n",
    "\n",
    "2.  Cost Reduction Maintain an expanded menu for special orders while eliminating other less popular items. This will reduce costs related to bookkeeping, staff training, and storage. Additionally, optimizing supply-based costs can significantly enhance efficiency.\n",
    "\n",
    "3.  Seasonal Menu Implementing a seasonal menu helps maintain a wide assortment with minimal costs. This allows adaptation to demand changes and offers customers new and exciting products.\n",
    "\n",
    "4.  Additional Analysis To derive more precise conclusions and recommendations, a deeper data analysis is necessary. For example, knowing the profitability of each item will enable more informed decisions about which products to retain in the assortment.\n"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 20,
   "id": "f018f5b7",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2024-06-02T22:23:24.877956Z",
     "iopub.status.busy": "2024-06-02T22:23:24.876128Z",
     "iopub.status.idle": "2024-06-02T22:23:24.928307Z",
     "shell.execute_reply": "2024-06-02T22:23:24.925322Z"
    },
    "papermill": {
     "duration": 0.074688,
     "end_time": "2024-06-02T22:23:24.931042",
     "exception": false,
     "start_time": "2024-06-02T22:23:24.856354",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "\u001b[90m# A tibble: 29 × 5\u001b[39m\n",
      "   fixed_article       income    prop cumulative_procent category\n",
      "   \u001b[3m\u001b[90m<chr>\u001b[39m\u001b[23m                \u001b[3m\u001b[90m<dbl>\u001b[39m\u001b[23m   \u001b[3m\u001b[90m<dbl>\u001b[39m\u001b[23m              \u001b[3m\u001b[90m<dbl>\u001b[39m\u001b[23m \u001b[3m\u001b[90m<chr>\u001b[39m\u001b[23m   \n",
      "\u001b[90m 1\u001b[39m tarte fraise         \u001b[4m4\u001b[24m562  0.008\u001b[4m1\u001b[24m\u001b[4m1\u001b[24m               80.2 B       \n",
      "\u001b[90m 2\u001b[39m pain banette         \u001b[4m4\u001b[24m419. 0.007\u001b[4m8\u001b[24m\u001b[4m5\u001b[24m               81.0 B       \n",
      "\u001b[90m 3\u001b[39m divers viennoiserie  \u001b[4m4\u001b[24m294. 0.007\u001b[4m6\u001b[24m\u001b[4m3\u001b[24m               81.8 B       \n",
      "\u001b[90m 4\u001b[39m financier x          \u001b[4m4\u001b[24m148  0.007\u001b[4m3\u001b[24m\u001b[4m7\u001b[24m               82.5 B       \n",
      "\u001b[90m 5\u001b[39m pain aux raisins     \u001b[4m3\u001b[24m997. 0.007\u001b[4m1\u001b[24m\u001b[4m0\u001b[24m               83.2 B       \n",
      "\u001b[90m 6\u001b[39m cookie               \u001b[4m3\u001b[24m990. 0.007\u001b[4m0\u001b[24m\u001b[4m9\u001b[24m               83.9 B       \n",
      "\u001b[90m 7\u001b[39m coupe                \u001b[4m3\u001b[24m540. 0.006\u001b[4m2\u001b[24m\u001b[4m9\u001b[24m               84.6 B       \n",
      "\u001b[90m 8\u001b[39m croissant amandes    \u001b[4m3\u001b[24m453. 0.006\u001b[4m1\u001b[24m\u001b[4m4\u001b[24m               85.2 B       \n",
      "\u001b[90m 9\u001b[39m plat 7.              \u001b[4m3\u001b[24m284. 0.005\u001b[4m8\u001b[24m\u001b[4m4\u001b[24m               85.8 B       \n",
      "\u001b[90m10\u001b[39m gal frangipane       \u001b[4m3\u001b[24m248  0.005\u001b[4m7\u001b[24m\u001b[4m7\u001b[24m               86.3 B       \n",
      "\u001b[90m11\u001b[39m royal                \u001b[4m3\u001b[24m204. 0.005\u001b[4m6\u001b[24m\u001b[4m9\u001b[24m               86.9 B       \n",
      "\u001b[90m12\u001b[39m pain choco amandes   \u001b[4m2\u001b[24m989  0.005\u001b[4m3\u001b[24m\u001b[4m1\u001b[24m               87.4 B       \n",
      "\u001b[90m13\u001b[39m pain                 \u001b[4m2\u001b[24m965  0.005\u001b[4m2\u001b[24m\u001b[4m7\u001b[24m               88.0 B       \n",
      "\u001b[90m14\u001b[39m divers patisserie    \u001b[4m2\u001b[24m881. 0.005\u001b[4m1\u001b[24m\u001b[4m2\u001b[24m               88.5 B       \n",
      "\u001b[90m15\u001b[39m chausson aux pommes  \u001b[4m2\u001b[24m835. 0.005\u001b[4m0\u001b[24m\u001b[4m4\u001b[24m               89.0 B       \n",
      "\u001b[90m16\u001b[39m boisson              \u001b[4m2\u001b[24m832  0.005\u001b[4m0\u001b[24m\u001b[4m3\u001b[24m               89.5 B       \n",
      "\u001b[90m17\u001b[39m paris brest          \u001b[4m2\u001b[24m664. 0.004\u001b[4m7\u001b[24m\u001b[4m3\u001b[24m               90.0 B       \n",
      "\u001b[90m18\u001b[39m seigle               \u001b[4m2\u001b[24m655. 0.004\u001b[4m7\u001b[24m\u001b[4m2\u001b[24m               90.4 B       \n",
      "\u001b[90m19\u001b[39m tartelette fraise    \u001b[4m2\u001b[24m634. 0.004\u001b[4m6\u001b[24m\u001b[4m8\u001b[24m               90.9 B       \n",
      "\u001b[90m20\u001b[39m baguette graine      \u001b[4m2\u001b[24m481. 0.004\u001b[4m4\u001b[24m\u001b[4m1\u001b[24m               91.3 B       \n",
      "\u001b[90m21\u001b[39m pt nantais           \u001b[4m2\u001b[24m470. 0.004\u001b[4m3\u001b[24m\u001b[4m9\u001b[24m               91.8 B       \n",
      "\u001b[90m22\u001b[39m quim bread           \u001b[4m2\u001b[24m314. 0.004\u001b[4m1\u001b[24m\u001b[4m1\u001b[24m               92.2 B       \n",
      "\u001b[90m23\u001b[39m special bread kg     \u001b[4m2\u001b[24m272. 0.004\u001b[4m0\u001b[24m\u001b[4m4\u001b[24m               92.6 B       \n",
      "\u001b[90m# ℹ 6 more rows\u001b[39m\n"
     ]
    }
   ],
   "source": [
    "final_shape %>% \n",
    "  filter(category == \"B\") %>% \n",
    "  print(n = 23)"
   ]
  }
 ],
 "metadata": {
  "kaggle": {
   "accelerator": "none",
   "dataSources": [
    {
     "datasetId": 2609620,
     "sourceId": 4457754,
     "sourceType": "datasetVersion"
    }
   ],
   "isGpuEnabled": false,
   "isInternetEnabled": false,
   "language": "r",
   "sourceType": "notebook"
  },
  "kernelspec": {
   "display_name": "R",
   "language": "R",
   "name": "ir"
  },
  "language_info": {
   "codemirror_mode": "r",
   "file_extension": ".r",
   "mimetype": "text/x-r-source",
   "name": "R",
   "pygments_lexer": "r",
   "version": "4.0.5"
  },
  "papermill": {
   "default_parameters": {},
   "duration": 11.939691,
   "end_time": "2024-06-02T22:23:25.071874",
   "environment_variables": {},
   "exception": null,
   "input_path": "__notebook__.ipynb",
   "output_path": "__notebook__.ipynb",
   "parameters": {},
   "start_time": "2024-06-02T22:23:13.132183",
   "version": "2.5.0"
  }
 },
 "nbformat": 4,
 "nbformat_minor": 5
}
