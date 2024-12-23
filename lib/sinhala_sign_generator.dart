import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:characters/characters.dart';


class SinhalaSignGenerator {
  // Formation rules for compound letters
  final Map<String, List<String>> formationRules = {
    // Forms for ක
  'ක්': ['ක්'], 'ක': ['ක්', 'අ'], 'කා': ['ක්', 'ආ'], 'කැ': ['ක්', 'ඇ'],
  'කෑ': ['ක්', 'ඈ'], 'කි': ['ක්', 'ඉ'], 'කී': ['ක්', 'ඊ'], 'කු': ['ක්', 'උ'],
  'කූ': ['ක්', 'ඌ'], 'කෘ': ['ක්', 'රු'], 'කෲ': ['ක්', 'රූ'], 'කෙ': ['ක්', 'එ'],
  'කේ': ['ක්', 'ඒ'], 'කෛ': ['ක්', 'ඓ'], 'කො': ['ක්', 'ඔ'], 'කෝ': ['ක්', 'ඕ'], 'කෞ': ['ක්', 'ඖ'],

  // Forms for ඛ
  'ඛ්': ['ඛ්'], 'ඛ': ['ඛ්', 'අ'], 'ඛා': ['ඛ්', 'ආ'], 'ඛැ': ['ඛ්', 'ඇ'],
  'ඛෑ': ['ඛ්', 'ඈ'], 'ඛි': ['ඛ්', 'ඉ'], 'ඛී': ['ඛ්', 'ඊ'], 'ඛු': ['ඛ්', 'උ'],
  'ඛූ': ['ඛ්', 'ඌ'], 'ඛෘ': ['ඛ්', 'රු'], 'ඛෲ': ['ඛ්', 'රූ'], 'ඛෙ': ['ඛ්', 'එ'],
  'ඛේ': ['ඛ්', 'ඒ'], 'ඛෛ': ['ඛ්', 'ඓ'], 'ඛො': ['ඛ්', 'ඔ'], 'ඛෝ': ['ඛ්', 'ඕ'], 'ඛෞ': ['ඛ්', 'ඖ'],

  // Forms for ග
  'ග්': ['ග්'], 'ග': ['ග්', 'අ'], 'ගා': ['ග්', 'ආ'], 'ගැ': ['ග්', 'ඇ'],
  'ගෑ': ['ග්', 'ඈ'], 'ගි': ['ග්', 'ඉ'], 'ගී': ['ග්', 'ඊ'], 'ගු': ['ග්', 'උ'],
  'ගූ': ['ග්', 'ඌ'], 'ගෘ': ['ග්', 'රු'], 'ගෲ': ['ග්', 'රූ'], 'ගෙ': ['ග්', 'එ'],
  'ගේ': ['ග්', 'ඒ'], 'ගෛ': ['ග්', 'ඓ'], 'ගො': ['ග්', 'ඔ'], 'ගෝ': ['ග්', 'ඕ'], 'ගෞ': ['ග්', 'ඖ'],

  // Forms for ඝ
  'ඝ්': ['ඝ්'], 'ඝ': ['ඝ්', 'අ'], 'ඝා': ['ඝ්', 'ආ'], 'ඝැ': ['ඝ්', 'ඇ'],
  'ඝෑ': ['ඝ්', 'ඈ'], 'ඝි': ['ඝ්', 'ඉ'], 'ඝී': ['ඝ්', 'ඊ'], 'ඝු': ['ඝ්', 'උ'],
  'ඝූ': ['ඝ්', 'ඌ'], 'ඝෘ': ['ඝ්', 'රු'], 'ඝෲ': ['ඝ්', 'රූ'], 'ඝෙ': ['ඝ්', 'එ'],
  'ඝේ': ['ඝ්', 'ඒ'], 'ඝෛ': ['ඝ්', 'ඓ'], 'ඝො': ['ඝ්', 'ඔ'], 'ඝෝ': ['ඝ්', 'ඕ'], 'ඝෞ': ['ඝ්', 'ඖ'],

  // Forms for ඞ
  'ඞ්': ['ඞ්'], 'ඞ': ['ඞ්', 'අ'], 'ඞා': ['ඞ්', 'ආ'], 'ඞැ': ['ඞ්', 'ඇ'],
  'ඞෑ': ['ඞ්', 'ඈ'], 'ඞි': ['ඞ්', 'ඉ'], 'ඞී': ['ඞ්', 'ඊ'], 'ඞු': ['ඞ්', 'උ'],
  'ඞූ': ['ඞ්', 'ඌ'], 'ඞෘ': ['ඞ්', 'රු'], 'ඞෲ': ['ඞ්', 'රූ'], 'ඞෙ': ['ඞ්', 'එ'],
  'ඞේ': ['ඞ්', 'ඒ'], 'ඞෛ': ['ඞ්', 'ඓ'], 'ඞො': ['ඞ්', 'ඔ'], 'ඞෝ': ['ඞ්', 'ඕ'], 'ඞෞ': ['ඞ්', 'ඖ'],

  // Forms for  ච
  'ච්': ['ච්'], 'ච': ['ච්', 'අ'], 'චා': ['ච්', 'ආ'], 'චැ': ['ච්', 'ඇ'],
  'චෑ': ['ච්', 'ඈ'], 'චි': ['ච්', 'ඉ'], 'චී': ['ච්', 'ඊ'], 'චු': ['ච්', 'උ'],
  'චූ': ['ච්', 'ඌ'], 'චෘ': ['ච්', 'රු'], 'චෲ': ['ච්', 'රූ'], 'චෙ': ['ච්', 'එ'],
  'චේ': ['ච්', 'ඒ'], 'චෛ': ['ච්', 'ඓ'], 'චො': ['ච්', 'ඔ'], 'චෝ': ['ච්', 'ඕ'], 'චෞ': ['ච්', 'ඖ'],

   // Forms for ඡ
  'ඡ්': ['ඡ්'], 'ඡ': ['ඡ්', 'අ'], 'ඡා': ['ඡ්', 'ආ'], 'ඡැ': ['ඡ්', 'ඇ'],
  'ඡෑ': ['ඡ්', 'ඈ'], 'ඡි': ['ඡ්', 'ඉ'], 'ඡී': ['ඡ්', 'ඊ'], 'ඡු': ['ඡ්', 'උ'],
  'ඡූ': ['ඡ්', 'ඌ'], 'ඡෘ': ['ඡ්', 'රු'], 'ඡෲ': ['ඡ්', 'රූ'], 'ඡෙ': ['ඡ්', 'එ'],
  'ඡේ': ['ඡ්', 'ඒ'], 'ඡෛ': ['ඡ්', 'ඓ'], 'ඡො': ['ඡ්', 'ඔ'], 'ඡෝ': ['ඡ්', 'ඕ'], 'ඡෞ': ['ඡ්', 'ඖ'],

  // Forms for ජ
  'ජ්': ['ජ්'], 'ජ': ['ජ්', 'අ'], 'ජා': ['ජ්', 'ආ'], 'ජැ': ['ජ්', 'ඇ'],
  'ජෑ': ['ජ්', 'ඈ'], 'ජි': ['ජ්', 'ඉ'], 'ජී': ['ජ්', 'ඊ'], 'ජු': ['ජ්', 'උ'],
  'ජූ': ['ජ්', 'ඌ'], 'ජෘ': ['ජ්', 'රු'], 'ජෲ': ['ජ්', 'රූ'], 'ජෙ': ['ජ්', 'එ'],
  'ජේ': ['ජ්', 'ඒ'], 'ජෛ': ['ජ්', 'ඓ'], 'ජො': ['ජ්', 'ඔ'], 'ජෝ': ['ජ්', 'ඕ'], 'ජෞ': ['ජ්', 'ඖ'],

  // Forms for ඤ
  'ඤ්': ['ඤ්'], 'ඤ': ['ඤ්', 'අ'], 'ඤා': ['ඤ්', 'ආ'], 'ඤැ': ['ඤ්', 'ඇ'],
  'ඤෑ': ['ඤ්', 'ඈ'], 'ඤි': ['ඤ්', 'ඉ'], 'ඤී': ['ඤ්', 'ඊ'], 'ඤු': ['ඤ්', 'උ'],
  'ඤූ': ['ඤ්', 'ඌ'], 'ඤෘ': ['ඤ්', 'රු'], 'ඤෲ': ['ඤ්', 'රූ'], 'ඤෙ': ['ඤ්', 'එ'],
  'ඤේ': ['ඤ්', 'ඒ'], 'ඤෛ': ['ඤ්', 'ඓ'], 'ඤො': ['ඤ්', 'ඔ'], 'ඤෝ': ['ඤ්', 'ඕ'], 'ඤෞ': ['ඤ්', 'ඖ'],

  // Forms for ඥ
  'ඥ්': ['ඥ්'], 'ඥ': ['ඥ්', 'අ'], 'ඥා': ['ඥ්', 'ආ'], 'ඥැ': ['ඥ්', 'ඇ'],
  'ඥෑ': ['ඥ්', 'ඈ'], 'ඥි': ['ඥ්', 'ඉ'], 'ඥී': ['ඥ්', 'ඊ'], 'ඥු': ['ඥ්', 'උ'],
  'ඥූ': ['ඥ්', 'ඌ'], 'ඥෘ': ['ඥ්', 'රු'], 'ඥෲ': ['ඥ්', 'රූ'], 'ඥෙ': ['ඥ්', 'එ'],
  'ඥේ': ['ඥ්', 'ඒ'], 'ඥෛ': ['ඥ්', 'ඓ'], 'ඥො': ['ඥ්', 'ඔ'], 'ඥෝ': ['ඥ්', 'ඕ'], 'ඥෞ': ['ඥ්', 'ඖ'],

  // Forms for ට
  'ට්': ['ට්'], 'ට': ['ට්', 'අ'], 'ටා': ['ට්', 'ආ'], 'ටැ': ['ට්', 'ඇ'],
  'ටෑ': ['ට්', 'ඈ'], 'ටි': ['ට්', 'ඉ'], 'ටී': ['ට්', 'ඊ'], 'ටු': ['ට්', 'උ'],
  'ටූ': ['ට්', 'ඌ'], 'ටෘ': ['ට්', 'රු'], 'ටෲ': ['ට්', 'රූ'], 'ටෙ': ['ට්', 'එ'],
  'ටේ': ['ට්', 'ඒ'], 'ටෛ': ['ට්', 'ඓ'], 'ටො': ['ට්', 'ඔ'], 'ටෝ': ['ට්', 'ඕ'], 'ටෞ': ['ට්', 'ඖ'],

  // Forms for ඨ
  'ඨ්': ['ඨ්'], 'ඨ': ['ඨ්', 'අ'], 'ඨා': ['ඨ්', 'ආ'], 'ඨැ': ['ඨ්', 'ඇ'],
  'ඨෑ': ['ඨ්', 'ඈ'], 'ඨි': ['ඨ්', 'ඉ'], 'ඨී': ['ඨ්', 'ඊ'], 'ඨු': ['ඨ්', 'උ'],
  'ඨූ': ['ඨ්', 'ඌ'], 'ඨෘ': ['ඨ්', 'රු'], 'ඨෲ': ['ඨ්', 'රූ'], 'ඨෙ': ['ඨ්', 'එ'],
  'ඨේ': ['ඨ්', 'ඒ'], 'ඨෛ': ['ඨ්', 'ඓ'], 'ඨො': ['ඨ්', 'ඔ'], 'ඨෝ': ['ඨ්', 'ඕ'], 'ඨෞ': ['ඨ්', 'ඖ'],

  // Forms for ඩ
  'ඩ්': ['ඩ්'], 'ඩ': ['ඩ්', 'අ'], 'ඩා': ['ඩ්', 'ආ'], 'ඩැ': ['ඩ්', 'ඇ'],
  'ඩෑ': ['ඩ්', 'ඈ'], 'ඩි': ['ඩ්', 'ඉ'], 'ඩී': ['ඩ්', 'ඊ'], 'ඩු': ['ඩ්', 'උ'],
  'ඩූ': ['ඩ්', 'ඌ'], 'ඩෘ': ['ඩ්', 'රු'], 'ඩෲ': ['ඩ්', 'රූ'], 'ඩෙ': ['ඩ්', 'එ'],
  'ඩේ': ['ඩ්', 'ඒ'], 'ඩෛ': ['ඩ්', 'ඓ'], 'ඩො': ['ඩ්', 'ඔ'], 'ඩෝ': ['ඩ්', 'ඕ'], 'ඩෞ': ['ඩ්', 'ඖ'],

  // Forms for ණ
  'ණ්': ['ණ්'], 'ණ': ['ණ්', 'අ'], 'ණා': ['ණ්', 'ආ'], 'ණැ': ['ණ්', 'ඇ'],
  'ණෑ': ['ණ්', 'ඈ'], 'ණි': ['ණ්', 'ඉ'], 'ණී': ['ණ්', 'ඊ'], 'ණු': ['ණ්', 'උ'],
  'ණූ': ['ණ්', 'ඌ'], 'ණෘ': ['ණ්', 'රු'], 'ණෲ': ['ණ්', 'රූ'], 'ණෙ': ['ණ්', 'එ'],
  'ණේ': ['ණ්', 'ඒ'], 'ණෛ': ['ණ්', 'ඓ'], 'ණො': ['ණ්', 'ඔ'], 'ණෝ': ['ණ්', 'ඕ'], 'ණෞ': ['ණ්', 'ඖ'],

  // Forms for ත
  'ත්': ['ත්'], 'ත': ['ත්', 'අ'], 'තා': ['ත්', 'ආ'], 'තැ': ['ත්', 'ඇ'],
  'තෑ': ['ත්', 'ඈ'], 'ති': ['ත්', 'ඉ'], 'තී': ['ත්', 'ඊ'], 'තු': ['ත්', 'උ'],
  'තූ': ['ත්', 'ඌ'], 'තෘ': ['ත්', 'රු'], 'තෲ': ['ත්', 'රූ'], 'තෙ': ['ත්', 'එ'],
  'තේ': ['ත්', 'ඒ'], 'තෛ': ['ත්', 'ඓ'], 'තො': ['ත්', 'ඔ'], 'තෝ': ['ත්', 'ඕ'], 'තෞ': ['ත්', 'ඖ'],

  // Forms for න
  'න්': ['න්'], 'න': ['න්', 'අ'], 'නා': ['න්', 'ආ'], 'නැ': ['න්', 'ඇ'],
  'නෑ': ['න්', 'ඈ'], 'නි': ['න්', 'ඉ'], 'නී': ['න්', 'ඊ'], 'නු': ['න්', 'උ'],
  'නූ': ['න්', 'ඌ'], 'නෘ': ['න්', 'රු'], 'නෲ': ['න්', 'රූ'], 'නෙ': ['න්', 'එ'],
  'නේ': ['න්', 'ඒ'], 'නෛ': ['න්', 'ඓ'], 'නො': ['න්', 'ඔ'], 'නෝ': ['න්', 'ඕ'], 'නෞ': ['න්', 'ඖ'],
  
  // Forms for ඤ (example of different base consonants for demonstration)
  'ඤ්': ['ඤ්'], 'ඤ': ['ඤ්', 'අ'], 'ඤා': ['ඤ්', 'ආ'], 'ඤැ': ['ඤ්', 'ඇ'],
  'ඤෑ': ['ඤ්', 'ඈ'], 'ඤි': ['ඤ්', 'ඉ'], 'ඤී': ['ඤ්', 'ඊ'], 'ඤු': ['ඤ්', 'උ'],
  'ඤූ': ['ඤ්', 'ඌ'], 'ඤෘ': ['ඤ්', 'රු'], 'ඤෲ': ['ඤ්', 'රූ'], 'ඤෙ': ['ඤ්', 'එ'],
  'ඤේ': ['ඤ්', 'ඒ'], 'ඤෛ': ['ඤ්', 'ඓ'], 'ඤො': ['ඤ්', 'ඔ'], 'ඤෝ': ['ඤ්', 'ඕ'], 'ඤෞ': ['ඤ්', 'ඖ'],

   // Forms for ඥ
  'ඥ්': ['ඥ්'], 'ඥ': ['ඥ්', 'අ'], 'ඥා': ['ඥ්', 'ආ'], 'ඥැ': ['ඥ්', 'ඇ'],
  'ඥෑ': ['ඥ්', 'ඈ'], 'ඥි': ['ඥ්', 'ඉ'], 'ඥී': ['ඥ්', 'ඊ'], 'ඥු': ['ඥ්', 'උ'],
  'ඥූ': ['ඥ්', 'ඌ'], 'ඥෘ': ['ඥ්', 'රු'], 'ඥෲ': ['ඥ්', 'රූ'], 'ඥෙ': ['ඥ්', 'එ'],
  'ඥේ': ['ඥ්', 'ඒ'], 'ඥෛ': ['ඥ්', 'ඓ'], 'ඥො': ['ඥ්', 'ඔ'], 'ඥෝ': ['ඥ්', 'ඕ'], 'ඥෞ': ['ඥ්', 'ඖ'],
  
  // Forms for ඦ
  'ඦ්': ['ඦ්'], 'ඦ': ['ඦ්', 'අ'], 'ඦා': ['ඦ්', 'ආ'], 'ඦැ': ['ඦ්', 'ඇ'],
  'ඦෑ': ['ඦ්', 'ඈ'], 'ඦි': ['ඦ්', 'ඉ'], 'ඦී': ['ඦ්', 'ඊ'], 'ඦු': ['ඦ්', 'උ'],
  'ඦූ': ['ඦ්', 'ඌ'], 'ඦෘ': ['ඦ්', 'රු'], 'ඦෲ': ['ඦ්', 'රූ'], 'ඦෙ': ['ඦ්', 'එ'],
  'ඦේ': ['ඦ්', 'ඒ'], 'ඦෛ': ['ඦ්', 'ඓ'], 'ඦො': ['ඦ්', 'ඔ'], 'ඦෝ': ['ඦ්', 'ඕ'], 'ඦෞ': ['ඦ්', 'ඖ'],
  
  // Forms for ඩ
  'ඩ්': ['ඩ්'], 'ඩ': ['ඩ්', 'අ'], 'ඩා': ['ඩ්', 'ආ'], 'ඩැ': ['ඩ්', 'ඇ'],
  'ඩෑ': ['ඩ්', 'ඈ'], 'ඩි': ['ඩ්', 'ඉ'], 'ඩී': ['ඩ්', 'ඊ'], 'ඩු': ['ඩ්', 'උ'],
  'ඩූ': ['ඩ්', 'ඌ'], 'ඩෘ': ['ඩ්', 'රු'], 'ඩෲ': ['ඩ්', 'රූ'], 'ඩෙ': ['ඩ්', 'එ'],
  'ඩේ': ['ඩ්', 'ඒ'], 'ඩෛ': ['ඩ්', 'ඓ'], 'ඩො': ['ඩ්', 'ඔ'], 'ඩෝ': ['ඩ්', 'ඕ'], 'ඩෞ': ['ඩ්', 'ඖ'],
  
  // Forms for ඪ
  'ඪ්': ['ඪ්'], 'ඪ': ['ඪ්', 'අ'], 'ඪා': ['ඪ්', 'ආ'], 'ඪැ': ['ඪ්', 'ඇ'],
  'ඪෑ': ['ඪ්', 'ඈ'], 'ඪි': ['ඪ්', 'ඉ'], 'ඪී': ['ඪ්', 'ඊ'], 'ඪු': ['ඪ්', 'උ'],
  'ඪූ': ['ඪ්', 'ඌ'], 'ඪෘ': ['ඪ්', 'රු'], 'ඪෲ': ['ඪ්', 'රූ'], 'ඪෙ': ['ඪ්', 'එ'],
  'ඪේ': ['ඪ්', 'ඒ'], 'ඪෛ': ['ඪ්', 'ඓ'], 'ඪො': ['ඪ්', 'ඔ'], 'ඪෝ': ['ඪ්', 'ඕ'], 'ඪෞ': ['ඪ්', 'ඖ'],
  
  // Forms for න
  'න්': ['න්'], 'න': ['න්', 'අ'], 'නා': ['න්', 'ආ'], 'නැ': ['න්', 'ඇ'],
  'නෑ': ['න්', 'ඈ'], 'නි': ['න්', 'ඉ'], 'නී': ['න්', 'ඊ'], 'නු': ['න්', 'උ'],
  'නූ': ['න්', 'ඌ'], 'නෘ': ['න්', 'රු'], 'නෲ': ['න්', 'රූ'], 'නෙ': ['න්', 'එ'],
  'නේ': ['න්', 'ඒ'], 'නෛ': ['න්', 'ඓ'], 'නො': ['න්', 'ඔ'], 'නෝ': ['න්', 'ඕ'], 'නෞ': ['න්', 'ඖ'],
  
  // Forms for ඬ
  'ඬ්': ['ඬ්'], 'ඬ': ['ඬ්', 'අ'], 'ඬා': ['ඬ්', 'ආ'], 'ඬැ': ['ඬ්', 'ඇ'],
  'ඬෑ': ['ඬ්', 'ඈ'], 'ඬි': ['ඬ්', 'ඉ'], 'ඬී': ['ඬ්', 'ඊ'], 'ඬු': ['ඬ්', 'උ'],
  'ඬූ': ['ඬ්', 'ඌ'], 'ඬෘ': ['ඬ්', 'රු'], 'ඬෲ': ['ඬ්', 'රූ'], 'ඬෙ': ['ඬ්', 'එ'],
  'ඬේ': ['ඬ්', 'ඒ'], 'ඬෛ': ['ඬ්', 'ඓ'], 'ඬො': ['ඬ්', 'ඔ'], 'ඬෝ': ['ඬ්', 'ඕ'], 'ඬෞ': ['ඬ්', 'ඖ'],
  
  // Forms for ප
  'ප්': ['ප්'], 'ප': ['ප්', 'අ'], 'පා': ['ප්', 'ආ'], 'පැ': ['ප්', 'ඇ'],
  'පෑ': ['ප්', 'ඈ'], 'පි': ['ප්', 'ඉ'], 'පී': ['ප්', 'ඊ'], 'පු': ['ප්', 'උ'],
  'පූ': ['ප්', 'ඌ'], 'පෘ': ['ප්', 'රු'], 'පෲ': ['ප්', 'රූ'], 'පෙ': ['ප්', 'එ'],
  'පේ': ['ප්', 'ඒ'], 'පෛ': ['ප්', 'ඓ'], 'පො': ['ප්', 'ඔ'], 'පෝ': ['ප්', 'ඕ'], 'පෞ': ['ප්', 'ඖ'],
  
  // Forms for ඵ
  'ඵ්': ['ඵ්'], 'ඵ': ['ඵ්', 'අ'], 'ඵා': ['ඵ්', 'ආ'], 'ඵැ': ['ඵ්', 'ඇ'],
  'ඵෑ': ['ඵ්', 'ඈ'], 'ඵි': ['ඵ්', 'ඉ'], 'ඵී': ['ඵ්', 'ඊ'], 'ඵු': ['ඵ්', 'උ'],
  'ඵූ': ['ඵ්', 'ඌ'], 'ඵෘ': ['ඵ්', 'රු'], 'ඵෲ': ['ඵ්', 'රූ'], 'ඵෙ': ['ඵ්', 'එ'],
  'ඵේ': ['ඵ්', 'ඒ'], 'ඵෛ': ['ඵ්', 'ඓ'], 'ඵො': ['ඵ්', 'ඔ'], 'ඵෝ': ['ඵ්', 'ඕ'], 'ඵෞ': ['ඵ්', 'ඖ'],
  
  // Forms for බ
  'බ්': ['බ්'], 'බ': ['බ්', 'අ'], 'බා': ['බ්', 'ආ'], 'බැ': ['බ්', 'ඇ'],
  'බෑ': ['බ්', 'ඈ'], 'බි': ['බ්', 'ඉ'], 'බී': ['බ්', 'ඊ'], 'බු': ['බ්', 'උ'],
  'බූ': ['බ්', 'ඌ'], 'බෘ': ['බ්', 'රු'], 'බෲ': ['බ්', 'රූ'], 'බෙ': ['බ්', 'එ'],
  'බේ': ['බ්', 'ඒ'], 'බෛ': ['බ්', 'ඓ'], 'බො': ['බ්', 'ඔ'], 'බෝ': ['බ්', 'ඕ'], 'බෞ': ['බ්', 'ඖ'],
  
  // Forms for භ
  'භ්': ['භ්'], 'භ': ['භ්', 'අ'], 'භා': ['භ්', 'ආ'], 'භැ': ['භ්', 'ඇ'],
  'භෑ': ['භ්', 'ඈ'], 'භි': ['භ්', 'ඉ'], 'භී': ['භ්', 'ඊ'], 'භු': ['භ්', 'උ'],
  'භූ': ['භ්', 'ඌ'], 'භෘ': ['භ්', 'රු'], 'භෲ': ['භ්', 'රූ'], 'භෙ': ['භ්', 'එ'],
  'භේ': ['භ්', 'ඒ'], 'භෛ': ['භ්', 'ඓ'], 'භො': ['භ්', 'ඔ'], 'භෝ': ['භ්', 'ඕ'], 'භෞ': ['භ්', 'ඖ'],
  
  // Forms for ම
  'ම්': ['ම්'], 'ම': ['ම්', 'අ'], 'මා': ['ම්', 'ආ'], 'මැ': ['ම්', 'ඇ'],
  'මෑ': ['ම්', 'ඈ'], 'මි': ['ම්', 'ඉ'], 'මී': ['ම්', 'ඊ'], 'මු': ['ම්', 'උ'],
  'මූ': ['ම්', 'ඌ'], 'මෘ': ['ම්', 'රු'], 'මෲ': ['ම්', 'රූ'], 'මෙ': ['ම්', 'එ'],
  'මේ': ['ම්', 'ඒ'], 'මෛ': ['ම්', 'ඓ'], 'මො': ['ම්', 'ඔ'], 'මෝ': ['ම්', 'ඕ'], 'මෞ': ['ම්', 'ඖ'],
  
  // Forms for ය
  'ය්': ['ය්'], 'ය': ['ය්', 'අ'], 'යා': ['ය්', 'ආ'], 'යැ': ['ය්', 'ඇ'],
  'යෑ': ['ය්', 'ඈ'], 'යි': ['ය්', 'ඉ'], 'යී': ['ය්', 'ඊ'], 'යු': ['ය්', 'උ'],
  'යූ': ['ය්', 'ඌ'], 'යෘ': ['ය්', 'රු'], 'යෲ': ['ය්', 'රූ'], 'යෙ': ['ය්', 'එ'],
  'යේ': ['ය්', 'ඒ'], 'යෛ': ['ය්', 'ඓ'], 'යො': ['ය්', 'ඔ'], 'යෝ': ['ය්', 'ඕ'], 'යෞ': ['ය්', 'ඖ'],

// Forms for ර
  'ර්': ['ර්'], 'ර': ['ර්', 'අ'], 'රා': ['ර්', 'ආ'], 'රැ': ['ර්', 'ඇ'],
  'රෑ': ['ර්', 'ඈ'], 'රි': ['ර්', 'ඉ'], 'රී': ['ර්', 'ඊ'], 'රු': ['ර්', 'උ'],
  'රූ': ['ර්', 'ඌ'], 'රෘ': ['ර්', 'රු'], 'රෲ': ['ර්', 'රූ'], 'රෙ': ['ර්', 'එ'],
  'රේ': ['ර්', 'ඒ'], 'රෛ': ['ර්', 'ඓ'], 'රො': ['ර්', 'ඔ'], 'රෝ': ['ර්', 'ඕ'], 'රෞ': ['ර්', 'ඖ'],

  // Forms for ල
  'ල්': ['ල්'], 'ල': ['ල්', 'අ'], 'ලා': ['ල්', 'ආ'], 'ලැ': ['ල්', 'ඇ'],
  'ලෑ': ['ල්', 'ඈ'], 'ලි': ['ල්', 'ඉ'], 'ලී': ['ල්', 'ඊ'], 'ලු': ['ල්', 'උ'],
  'ලූ': ['ල්', 'ඌ'], 'ලෘ': ['ල්', 'රු'], 'ලෲ': ['ල්', 'රූ'], 'ලෙ': ['ල්', 'එ'],
  'ලේ': ['ල්', 'ඒ'], 'ලෛ': ['ල්', 'ඓ'], 'ලො': ['ල්', 'ඔ'], 'ලෝ': ['ල්', 'ඕ'], 'ලෞ': ['ල්', 'ඖ'],

  // Forms for ව
  'ව්': ['ව්'], 'ව': ['ව්', 'අ'], 'වා': ['ව්', 'ආ'], 'වැ': ['ව්', 'ඇ'],
  'වෑ': ['ව්', 'ඈ'], 'වි': ['ව්', 'ඉ'], 'වී': ['ව්', 'ඊ'], 'වු': ['ව්', 'උ'],
  'වූ': ['ව්', 'ඌ'], 'වෘ': ['ව්', 'රු'], 'වෲ': ['ව්', 'රූ'], 'වෙ': ['ව්', 'එ'],
  'වේ': ['ව්', 'ඒ'], 'වෛ': ['ව්', 'ඓ'], 'වො': ['ව්', 'ඔ'], 'වෝ': ['ව්', 'ඕ'], 'වෞ': ['ව්', 'ඖ'],

  // Forms for ශ
  'ෂ්': ['ෂ්'], 'ශ': ['ෂ්', 'අ'], 'ශා': ['ෂ්', 'ආ'], 'ශැ': ['ෂ්', 'ඇ'],
  'ශෑ': ['ෂ්', 'ඈ'], 'ශි': ['ෂ්', 'ඉ'], 'ශී': ['ෂ්', 'ඊ'], 'ශු': ['ෂ්', 'උ'],
  'ශූ': ['ෂ්', 'ඌ'], 'ෂෘ': ['ෂ්', 'රු'], 'ෂෲ': ['ෂ්', 'රූ'], 'ෂෙ': ['ෂ්', 'එ'],
  'ෂේ': ['ෂ්', 'ඒ'], 'ෂෛ': ['ෂ්', 'ඓ'], 'ෂො': ['ෂ්', 'ඔ'], 'ෂෝ': ['ෂ්', 'ඕ'], 'ෂෞ': ['ෂ්', 'ඖ'],

  // Forms for ෂ
  'ෂ්': ['ෂ්'], 'ෂ': ['ෂ්', 'අ'], 'ෂා': ['ෂ්', 'ආ'], 'ෂැ': ['ෂ්', 'ඇ'],
  'ෂෑ': ['ෂ්', 'ඈ'], 'ෂි': ['ෂ්', 'ඉ'], 'ෂී': ['ෂ්', 'ඊ'], 'ෂු': ['ෂ්', 'උ'],
  'ෂූ': ['ෂ්', 'ඌ'], 'ෂෘ': ['ෂ්', 'රු'], 'ෂෲ': ['ෂ්', 'රූ'], 'ෂෙ': ['ෂ්', 'එ'],
  'ෂේ': ['ෂ්', 'ඒ'], 'ෂෛ': ['ෂ්', 'ඓ'], 'ෂො': ['ෂ්', 'ඔ'], 'ෂෝ': ['ෂ්', 'ඕ'], 'ෂෞ': ['ෂ්', 'ඖ'],

  // Forms for ස
  'ස්': ['ස්'], 'ස': ['ස්', 'අ'], 'සා': ['ස්', 'ආ'], 'සැ': ['ස්', 'ඇ'],
  'සෑ': ['ස්', 'ඈ'], 'සි': ['ස්', 'ඉ'], 'සී': ['ස්', 'ඊ'], 'සු': ['ස්', 'උ'],
  'සූ': ['ස්', 'ඌ'], 'සෘ': ['ස්', 'රු'], 'සෲ': ['ස්', 'රූ'], 'සෙ': ['ස්', 'එ'],
  'සේ': ['ස්', 'ඒ'], 'සෛ': ['ස්', 'ඓ'], 'සො': ['ස්', 'ඔ'], 'සෝ': ['ස්', 'ඕ'], 'සෞ': ['ස්', 'ඖ'],

  // Forms for හ
  'හ්': ['හ්'], 'හ': ['හ්', 'අ'], 'හා': ['හ්', 'ආ'], 'හැ': ['හ්', 'ඇ'],
  'හෑ': ['හ්', 'ඈ'], 'හි': ['හ්', 'ඉ'], 'හී': ['හ්', 'ඊ'], 'හු': ['හ්', 'උ'],
  'හූ': ['හ්', 'ඌ'], 'හෘ': ['හ්', 'රු'], 'හෲ': ['හ්', 'රූ'], 'හෙ': ['හ්', 'එ'],
  'හේ': ['හ්', 'ඒ'], 'හෛ': ['හ්', 'ඓ'], 'හො': ['හ්', 'ඔ'], 'හෝ': ['හ්', 'ඕ'], 'හෞ': ['හ්', 'ඖ'],

  // Forms for ෆ
  'ෆ්': ['ෆ්'], 'ෆ': ['ෆ්', 'අ'], 'ෆා': ['ෆ්', 'ආ'], 'ෆැ': ['ෆ්', 'ඇ'],
  'ෆෑ': ['ෆ්', 'ඈ'], 'ෆි': ['ෆ්', 'ඉ'], 'ෆී': ['ෆ්', 'ඊ'], 'ෆු': ['ෆ්', 'උ'],
  'ෆූ': ['ෆ්', 'ඌ'], 'ෆෘ': ['ෆ්', 'රු'], 'ෆෲ': ['ෆ්', 'රූ'], 'ෆෙ': ['ෆ්', 'එ'],
  'ෆේ': ['ෆ්', 'ඒ'], 'ෆෛ': ['ෆ්', 'ඓ'], 'ෆො': ['ෆ්', 'ඔ'], 'ෆෝ': ['ෆ්', 'ඕ'], 'ෆෞ': ['ෆ්', 'ඖ'],
  };

  // Function to fetch images for each decomposed component
  Future<List<String>> fetchSignImages(String word) async {
    List<String> images = [];

    for (var char in word.characters) {
      // Decompose character using formation rules
      List<String> components = formationRules[char] ?? [char];
      for (var component in components) {
        final imageUrl = 'http://192.168.42.58:3000/letter/$component';
        final response = await http.get(Uri.parse(imageUrl));
        if (response.statusCode == 200) {
          final imageData = json.decode(response.body)['image'];
          images.add(imageData); // Add Base64 image data
        } else {
          print('Error fetching image for component $component');
        }
      }
    }
    return images;
  }
}
