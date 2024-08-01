import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:dart_openai/dart_openai.dart';

class LLM {
  final String apiKey = dotenv.env["OPENAI_API_KEY"]!;

  Future<void> listModel() async {
    List<OpenAIModelModel> models = await OpenAI.instance.model.list();
    OpenAIModelModel firstModel = models.first;

    print(firstModel.id); // ...
    print(firstModel.permission);
  }

  Future<void> testFunction() async {
    OpenAIChatCompletionModel chatCompletion =
        await OpenAI.instance.chat.create(
      model: "gpt-4o",
      messages: [
        OpenAIChatCompletionChoiceMessageModel(
          role: OpenAIChatMessageRole.assistant,
          content: [
            OpenAIChatCompletionChoiceMessageContentItemModel.text(
                "You are a helpful assistant.")
          ],
        ),
        OpenAIChatCompletionChoiceMessageModel(
          role: OpenAIChatMessageRole.user,
          content: [
            OpenAIChatCompletionChoiceMessageContentItemModel.text(
                "Who is the CEO of Google?")
          ],
        ),
      ],
      maxTokens: 50,
    );

    print(chatCompletion.choices.first.message.content);
  }
}
